class LabSystem::LabKrokiClient < NetSystem::Client

  # 

  def self.call(name, action, output_format, &block)
    super({})
    new(name, action, output_format, &block).call
  end

  # diagrams

  def self.diagrams
    fetch(:diagrams) { {} }
  end

  def self.diagram name, endpoint, *formats
    diagrams[name] = {endpoint:, formats:}

    define_singleton_method name do |action, format, &block|
      call(name, action, format, &block)
    end

    define_singleton_method "new_#{name}" do |action, format, &block|
      new(name, action, format, &block)
    end
  end

  # define diagrams

  # TODO: https://kroki.io/#support

  # diagram :key, "/api", :png, :svg, :jpeg, :pdf, :txt, :base64
  diagram :plantuml, "/plantuml", :svg
  diagram :nomnoml, "/nomnoml", :svg

  #

  attr_reader :name, :action, :format, :result, :code, :cache_key

  def initialize(name, action, format, &block)
    @name = name
    @render_format = name
    @action = action
    @format = format
    @result = nil
    instance_exec(&block) if block_given?
  end

  #

  def call
    t = Time.now
    log "Calling #{endpoint} with #{action}.#{name}"

    render_code!
    read_cache!

    return @result if @result

    http_request!
    write_cache!

    @result
  ensure
    log "#{time_diff t}s to render #{action.inspect}"
    @result
  end

  #

  def endpoint
    self.class.diagrams[name][:endpoint]
  end

  def url
    "https://kroki.io/#{endpoint}"
  end

  #

  def render_code!
    @code = render! @action
    require "digest/md5"
    @code_md5 = Digest::MD5.hexdigest(@code)
  end

  def read_cache!
    raise "must be called after render_code!" unless @code_md5
    @cache_key = "tmp/#{App.mode}/clients/kokri/#{action}_#{@code_md5}.#{format}"
    log "cache_key = #{@cache_key.inspect}"
    @result = TextShell.read @cache_key if TextShell.exist? @cache_key
  end

  def write_cache!
    TextShell.write @cache_key, result
    cache_key = "tmp/#{App.mode}/clients/kokri/#{action}_#{@code_md5}.#{name}"
    TextShell.write cache_key, @code
  end

  def http_request!
    require "net/http"
    require "json"
    t = Time.now
    
    request_uri = URI(url)
    request_headers = {'Content-Type' => 'application/json'}
    request_body = {diagram_source: code, output_format: format}.to_json
    log "POST #{request_uri} #{request_headers.count} headers and #{request_body.size} bytes of data."
    @response = Net::HTTP.post(request_uri, request_body, request_headers)

    if @response.code == '200'
      @result = @response.body
    else
      puts "---- HTTP #{@response.code} ----"
      puts @response.body
      puts "----"
      raise "Error calling Kroki API. HTTP Status Code: #{@response.code}"
    end
  ensure
    log "#{time_diff t}s to request #{request_uri}"
  end

end

__END__

# view ab.plantuml.erb

@startuml
A <|.. B
@enduml

# view ab.nomnoml.erb

[A]<:-[B]
