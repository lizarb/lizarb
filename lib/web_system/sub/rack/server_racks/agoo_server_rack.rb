class WebSystem::AgooServerRack < WebSystem::ServerRack
  require "rack/handler/agoo"

  def self.call rack_app
    super({})
    rack_panel = WebBox[:rack]

    host = rack_panel.get :host
    port = rack_panel.get :port
    files = rack_panel.get :files

    Signal.trap(:INT) do
      puts
      log "Exiting..."
      Lizarb.exit
    end

    # https://github.com/ohler55/agoo/blob/develop/lib/rack/handler/agoo.rb
    handler = ::Rack::Handler::Agoo
    handler.run rack_app, Host: host, Port: port

    # TODO: improve custom configurability for agoo

    # https://github.com/ohler55/agoo/tree/develop/example

  end

end

# # env
# {
#   "REQUEST_METHOD"=>"GET",                                         
#   "SCRIPT_NAME"=>"",                                               
#   "PATH_INFO"=>"/",                                                
#   "QUERY_STRING"=>"",                                              
#   "REMOTE_ADDR"=>"127.0.0.1",                                      
#   "SERVER_PORT"=>"3000",                                           
#   "SERVER_NAME"=>"localhost",                                      
#   "HTTP_HOST"=>"localhost:3000",                                   
#   "HTTP_USER_AGENT"=>"curl/7.81.0",                                
#   "HTTP_ACCEPT"=>"*/*",
#   "rack.version"=>[1, 3],                                          
#   "rack.url_scheme"=>"http",                                       
#   "rack.input"=>#<StringIO:0x00007f480a0647e0>,                    
#   "rack.errors"=>#<Agoo::ErrorStream:0x00007f480a064768>,
#   "rack.multithread"=>false,
#   "rack.multiprocess"=>false,
#   "rack.run_once"=>false,
#   "rack.logger"=>#<Agoo::RackLogger:0x00007f480a064678>,
#   "rack.upgrade?"=>nil,
#   "rack.hijack?"=>true,
#   "rack.hijack"=>#<Agoo::Request:0x00007f480a064c18>,
#   "rack.hijack_io"=>nil
# }