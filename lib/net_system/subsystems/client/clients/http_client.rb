class NetSystem::HttpClient < NetSystem::Client
  require "uri"
  require "net/http"
  require "json"

  section :json

  def self.get_json(url, headers = {}, log_level: self.log_level)
    headers = HashRubyShell.merge_reverse headers, "Content-Type" => "application/json"
    get url, headers, log_level: log_level
  end

  def self.post_json(url, payload, headers = {}, log_level: self.log_level)
    headers = HashRubyShell.merge_reverse headers, "Content-Type" => "application/json"
    post url, payload, headers, log_level: log_level
  end

  section :xml

  def self.get_xml(url, headers = {})
    headers = HashRubyShell.merge_reverse headers, "Content-Type" => "application/xml"
    get url, headers
  end

  def self.post_xml(url, payload, headers = {})
    headers = HashRubyShell.merge_reverse headers, "Content-Type" => "application/xml"
    post url, payload, headers
  end

  section :http

  def self.get(url, headers = {}, log_level: :normal)
    return super(url) unless url.is_a? String

    menv = {log_level:,}
    call(menv)
    menv[:client].tap { _1.get url, headers }
    menv[:client]
  end

  def self.post(url, payload, headers = {}, log_level: :normal)
    menv = {log_level:,}
    call(menv)
    menv[:client].tap { _1.post url, payload, headers }
    menv[:client]
  end

  def self.call(menv)
    super
    new.call menv
    menv
  end

  section :instance

  menv_accessor :client

  attr_accessor :started_at, :request, :response, :finished_at, :elapsed_time

  def call(menv)
    super
    self.client = self
    log_level menv[:log_level] if menv[:log_level]
    menv
  end

  def get(url, headers = {})
    return super(url) unless url.is_a? String

    self.started_at = Time.now
    uri = URI url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true if uri.scheme == "https"
    log url

    self.request = Net::HTTP::Get.new(uri, headers)
    log_request

    self.response = http.request(request)
    self.finished_at = Time.now
    self.elapsed_time = finished_at - started_at
    log_response

    self
  end

  def post(url, payload, headers = {})
    self.started_at = Time.now
    uri = URI url
    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true if uri.scheme == "https"
    log url

    self.request = Net::HTTP::Post.new(uri, headers)
    request.body = payload
    log_request

    self.response = http.request(request)
    self.finished_at = Time.now
    self.elapsed_time = finished_at - started_at
    log_response

    self
  end

  def errors
    @errors ||= Hash.new.tap { _1.default_proc = proc { |h, k| h[k] = [] } }
  end

  def add_error(key, value)
    errors[key] << value
  end

  def response_code
    @response_code ||= response.code.to_i
  end

  def code
    response_code
  end

  def headers
    @headers ||= response.each_header.to_h
  end

  def body
    @body ||= response.body
  end

  def body_from_json
    return @body_from_json if defined? @body_from_json
    @body_from_json = JSON.parse body
  rescue JSON::ParserError => e
    add_error :invalid_json, e.message
    @body_from_json = false
  end

  def request_headers
    @request_headers ||= request.each_header.to_h
  end

  def response_headers
    @response_headers ||= response.each_header.to_h
  end

  def log_request
    log "#{request_headers.size} headers #{request.uri}"
    log_headers request_headers
  end

  def log_response
    log "#{time_diff started_at}s | STATUS: #{response.code} | HEADERS: #{response_headers.size} | BODY: #{response.body.size}"
    log_headers response_headers
    log_body response
  end

  def log_headers(hash)
    kaller = caller
    size = hash.map(&:first).map(&:to_s).map(&:size).max
    hash.each do |k, v|
      Array(v).each do |x|
        log "          #{k.to_s.ljust size} #{x}", kaller:
      end
    end
  end

  def log_body(response)
    log "size: #{response.body.size} | #{response.body.to_s[0..39].inspect}"
  end

end
