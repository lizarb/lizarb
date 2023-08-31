class WebSystem::RackPanel < Liza::Panel
  class NotSet < Error; end

  def call env
    puts

    env[:server] ||= get :server
    env[:host] ||= get :host
    env[:port] ||= get :port

    self.server env[:server]
    set :host, env[:host]
    set :port, env[:port]

    log(env)

    self.server.call(self.rack_app)
  end

  def server name = nil
    if name
      @server = Liza.const(:"#{name}_server_rack")
      set :server, name
    elsif @server.nil?
      raise NotSet, "Please set your rack server on your web_box.rb file", caller 
    else
      @server
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

    files ||= get :files
    rack_files = Object::Rack::Files.new files
    rack_app = Object::Rack::Cascade.new [rack_files, rack_app]
    
    rack_app
  end

end
