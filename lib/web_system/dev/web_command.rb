class WebSystem
  class WebCommand < Liza::Command

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000

    def self.call args
      log :higher, "Called #{self} with args #{args}"

      host = get :host
      port = get :port

      args.each do |arg|
        host = arg.split("=")[1] if arg.start_with? "h="
        port = arg.split("=")[1] if arg.start_with? "p="
      end

      if App.mode == :code
        ENV["RACK_ENV"] = "development"
        rack_app = method :_call
      else
        ENV["RACK_ENV"] = "production"
        rack_app = ::WebBox.requests
      end

      rack_files = Rack::Files.new get(:files)
      rack_app = Rack::Cascade.new [rack_files, rack_app]

      require "rack/handler/puma"
      Rack::Handler::Puma.run rack_app, Host: host, Port: port
    end

    def self._call app
      App.reload do
        log "reloading"
        return ::WebBox.requests.call app
      end
    end

  end
end
