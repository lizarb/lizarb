class WebSystem::RackPanel < Liza::Panel

  def call strategy, host, port
    puts
    log({strategy:, host:, port:})

    strategy ||= get :strategy
    host ||= get :host
    port ||= 3000
    files ||= get :files

    log({strategy:, host:, port:})

    x = App.mode == :code ? "development" : "production"
    ENV["RACK_ENV"] = x
    rack_app = send "get_rack_app_#{x}"

    rack_files = Object::Rack::Files.new files
    rack_app = Object::Rack::Cascade.new [rack_files, rack_app]

    # TODO: PumaRack
    # handler = Liza.const(:"#{strategy}_rack")

    require "rack/handler/puma"
    handler = Object::Rack::Handler::Puma
    handler.run rack_app, Host: host, Port: port
  end

  def get_rack_app_production()= WebBox[:request]

  def get_rack_app_development
    Proc.new do |env|
      ret = nil
      App.reload do
        log "reloading"
        ret = get_rack_app_production.call env
      end
      ret
    end
  end

end
