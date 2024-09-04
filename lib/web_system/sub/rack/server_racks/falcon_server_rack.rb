class WebSystem::FalconServerRack < WebSystem::ServerRack
  require "rack/handler/falcon"

  def self.call rack_app
    super({})
    rack_panel = WebBox[:rack]

    host = rack_panel.get :host
    port = rack_panel.get :port

    Signal.trap(:INT) do
      puts
      log "Exiting..."
      Lizarb.exit
    end

    # TODO: improve custom configurability for falcon

    handler = ::Rack::Handler::Falcon
    handler.run rack_app, Host: host, Port: port
  end

end

# env
# {
# "protocol.http.request"=>#<Async::HTTP::Protocol::HTTP1::Request:0x00007ff2fe019110>,
# "rack.input"=>#<Protocol::Rack::Input:0x00007ff2facd88c8 @body=nil, @buffer=nil, @closed=false>,
# "rack.errors"=>#<IO:<STDERR>>,
# "rack.logger"=>#<Console::Logger:0x00007ff2facb07b0>,
# "rack.protocol"=>nil,
# "rack.response_finished"=>[],
# "REQUEST_METHOD"=>"GET",
# "SCRIPT_NAME"=>"",
# "PATH_INFO"=>"/",
# "REQUEST_PATH"=>"/",
# "REQUEST_URI"=>"/",
# "QUERY_STRING"=>"",
# "SERVER_PROTOCOL"=>"HTTP/1.1",
# "rack.url_scheme"=>"http",
# "SERVER_NAME"=>"localhost",
# "SERVER_PORT"=>"3000",
# "HTTP_USER_AGENT"=>"curl/7.81.0",
# "HTTP_ACCEPT"=>"*/*",
# "HTTP_HOST"=>"localhost:3000",
# "REMOTE_ADDR"=>"127.0.0.1"
# }
