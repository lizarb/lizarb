class WebSystem::PumaServerRack < WebSystem::ServerRack
  require "rack/handler/puma"

  def self.call(menv)
    super
    rack_panel = WebBox[:rack]
    rack_app = menv[:rack_app]

    host = rack_panel.get :host
    port = rack_panel.get :port
    threads = $coding ? "1:1" : "5:5"

    handler = ::Rack::Handler::Puma
    handler.run rack_app, Host: host, Port: port, Threads: threads
  end

end

# env
# {
#   "rack.version"=>[1, 6],                                          
#   "rack.errors"=>#<IO:<STDERR>>,                                   
#   "rack.multithread"=>true,                                        
#   "rack.multiprocess"=>false,                                      
#   "rack.run_once"=>false,                                          
#   "rack.url_scheme"=>"http",                                       
#   "SCRIPT_NAME"=>"",                                               
#   "QUERY_STRING"=>"",                                              
#   "SERVER_PROTOCOL"=>"HTTP/1.1",                                   
#   "SERVER_SOFTWARE"=>"puma 5.6.5 Birdie's Version",                
#   "GATEWAY_INTERFACE"=>"CGI/1.2",                                  
#   "REQUEST_METHOD"=>"GET",                                         
#   "REQUEST_PATH"=>"/",                                             
#   "REQUEST_URI"=>"/",
#   "HTTP_VERSION"=>"HTTP/1.1",
#   "HTTP_HOST"=>"localhost:3001",
#   "HTTP_USER_AGENT"=>"curl/7.81.0",
#   "HTTP_ACCEPT"=>"*/*",
#   "puma.request_body_wait"=>0,
#   "SERVER_NAME"=>"localhost",
#   "SERVER_PORT"=>"3001",
#   "PATH_INFO"=>"/",
#   "REMOTE_ADDR"=>"127.0.0.1",
#   "puma.socket"=>#<TCPSocket:fd 14, AF_INET, 127.0.0.1, 3001>,
#   "rack.hijack?"=>true,
#   "rack.hijack"=>#<Puma::Client:0x61f8 @ready=true>,
#   "rack.input"=>#<Puma::NullIO:0x00007f75803f8bb0>,
#   "rack.after_reply"=>[],
#   "puma.config"=>
#    #<Puma::Configuration:0x00007f75803798d8>
# }
