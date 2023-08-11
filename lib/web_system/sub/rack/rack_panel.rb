class WebSystem::RackPanel < Liza::Panel

  def call strategy, host, port
    puts
    log({strategy:, host:, port:})

    strategy ||= get :strategy
    host ||= get :host
    port ||= 3000
    files ||= get :files

    log({strategy:, host:, port:})

    ENV["RACK_ENV"] = $coding ? "development" : "production"

    rack_app = WebBox[:request]
    rack_app = LastMiddleRack.new rack_app
    rack_app = FirstMiddleRack.new rack_app
    rack_app = ZeitwerkMiddleRack.new rack_app if $coding

    rack_files = Object::Rack::Files.new files
    rack_app = Object::Rack::Cascade.new [rack_files, rack_app]

    # TODO: PumaRack
    # handler = Liza.const(:"#{strategy}_rack")

    require "rack/handler/puma"
    handler = Object::Rack::Handler::Puma
    handler.run rack_app, Host: host, Port: port
  end

end
