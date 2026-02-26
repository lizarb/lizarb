class WebSystem::RackPanel < Liza::Panel

  define_error(:not_set) do |args|
    "Please set your rack server on your web_box.rb file"
  end

  def call(menv)
    puts

    menv[:server] ||= get :server
    menv[:host] ||= get :host
    menv[:port] ||= get :port

    self.server menv[:server]
    set :host, menv[:host]
    set :port, menv[:port]

    log(menv)
    menv[:rack_app] = rack_app

    self.server.call(menv)
  end

  def server name = nil
    if name
      @server_key = name
      set :server, name
    elsif @server_key.nil?
      raise_error :not_set
    else
      @server ||= Liza.const(:"#{@server_key}_server_rack")
    end
  end

  def rack_app
    return @rack_app if @rack_app

    rack_app = @rack_app = WebBox[:request]

    ENV["RACK_ENV"] = $coding ? "development" : "production"

    rack_app = WebBox[:request]
    rack_app = LastMiddleRack.new rack_app
    rack_app = FirstMiddleRack.new rack_app
    rack_app = ZeitwerkMiddleRack.new rack_app if $coding

    require "rack"

    files = get :files
    log "files is #{files.inspect}"
    rack_files = Object::Rack::Files.new files
    rack_app = Object::Rack::Cascade.new [rack_files, rack_app]
    
    rack_app
  end

end
