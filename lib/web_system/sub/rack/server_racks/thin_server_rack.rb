
class WebSystem::ThinServerRack < WebSystem::ServerRack

  def self.call rack_app
    rack_panel = WebBox[:rack]

    host = rack_panel.get :host
    port = rack_panel.get :port
    files = rack_panel.get :files

    ::Object.const_set :Fixnum, Class.new(Integer) unless defined? Fixnum
    
    require "thin"
    require "thin/server"
    require "thin/logging"
    require "thin/backends/tcp_server"

    ::Rack::Handler.register :thin, ThinHandler

    # TODO: improve custom configurability for thin

    # https://github.com/macournoyer/thin/tree/master/example

    handler = ThinHandler
    handler.run rack_app, Host: host, Port: port
  end

  # NOTE: I don't know why the file below is not included in the gem.
  # https://github.com/macournoyer/thin/blob/master/lib/rack/handler/thin.rb
  class ThinHandler
    def self.run(app, **options)
      environment  = ENV['RACK_ENV'] || 'development'
      default_host = environment == 'development' ? 'localhost' : '0.0.0.0'

      host = options.delete(:Host) || default_host
      port = options.delete(:Port) || 3000
      args = [host, port, app, options]

      server = ::Thin::Server.new(*args)
      yield server if block_given?

      server.start
    end

    def self.valid_options
      environment  = ENV['RACK_ENV'] || 'development'
      default_host = environment == 'development' ? 'localhost' : '0.0.0.0'

      {
        "Host=HOST" => "Hostname to listen on (default: #{default_host})",
        "Port=PORT" => "Port to listen on (default: 3000)",
      }
    end
  end

end

# # env
# {
# "SERVER_SOFTWARE"=>"thin 1.6.2 codename Doc Brown",              
# "SERVER_NAME"=>"localhost",                                      
# "rack.input"=>#<StringIO:0x00007f2ba03ce998>,                    
# "rack.version"=>[1, 0],                                          
# "rack.errors"=>#<IO:<STDERR>>,                                   
# "rack.multithread"=>false,                                       
# "rack.multiprocess"=>false,                                      
# "rack.run_once"=>false,                                          
# "REQUEST_METHOD"=>"GET",                                         
# "REQUEST_PATH"=>"/",                                             
# "PATH_INFO"=>"/",                                                
# "REQUEST_URI"=>"/",                                              
# "HTTP_VERSION"=>"HTTP/1.1",                                      
# "HTTP_HOST"=>"localhost:3000",
# "HTTP_USER_AGENT"=>"curl/7.81.0",
# "HTTP_ACCEPT"=>"*/*",
# "GATEWAY_INTERFACE"=>"CGI/1.2",
# "SERVER_PORT"=>"3000",
# "QUERY_STRING"=>"",
# "SERVER_PROTOCOL"=>"HTTP/1.1",
# "rack.url_scheme"=>"http",
# "SCRIPT_NAME"=>"",
# "REMOTE_ADDR"=>"127.0.0.1",
# "async.callback"=>#<Method: Thin::Connection#post_process(result) /home/pinto/.asdf/installs/ruby/3.2.0/lib/ruby/gems/3.2.0/gems/thin-1.6.2/lib/thin/connection.rb:95>,
# "async.close"=>#<EventMachine::DefaultDeferrable:0x00007f2ba03c3c28>}
# }
