class WebSystem::IodineServerRack < WebSystem::ServerRack
  require "rack/handler/iodine"

  def self.call(menv)
    super
    rack_panel = WebBox[:rack]
    rack_app = menv[:rack_app]

    host = rack_panel.get :host
    port = rack_panel.get :port

    # require "iodine"

    # TODO: improve custom configurability for iodine

    # https://github.com/boazsegev/iodine/tree/master/examples

    handler = ::Iodine::Rack
    handler.run rack_app, Host: host, Port: port
  end

end

# env
# {
# "rack.upgrade?"=>nil,                                            
# "rack.upgrade"=>nil,                                             
# "rack.version"=>[1, 3],                                          
# "SCRIPT_NAME"=>"",                                               
# "rack.input"=>#<Iodine::Base::RackIO:0x00007feff5a5a9f0>,        
# "rack.errors"=>#<IO:<STDERR>>,                                   
# "rack.hijack?"=>true,                                            
# "rack.multiprocess"=>true,                                       
# "rack.multithread"=>true,                                        
# "rack.run_once"=>false,                                          
# "rack.url_scheme"=>"http",                                       
# "HTTP_VERSION"=>"HTTP/1.1",                                      
# "rack.hijack"=>#<Method: Iodine::Base::RackIO#_hijack(*)>,       
# "PATH_INFO"=>"/",
# "QUERY_STRING"=>"",
# "REMOTE_ADDR"=>"127.0.0.1",
# "REQUEST_METHOD"=>"GET",
# "SERVER_NAME"=>"localhost",
# "SERVER_PROTOCOL"=>"HTTP/1.1",
# "SERVER_PORT"=>"3000",
# "HTTP_HOST"=>"localhost:3000",
# "HTTP_USER_AGENT"=>"curl/7.81.0",
# "HTTP_ACCEPT"=>"*/*"
# }
