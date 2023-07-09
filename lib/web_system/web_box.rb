class WebSystem::WebBox < Liza::Box

  # Configure your rack panel per the DSL in http://guides.lizarb.org/panels/rack.html
  configure :rack do
    # set :log_level, ENV["web.rack.log_level"]

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000
  end

  # Configure your request panel per the DSL in http://guides.lizarb.org/panels/request.html
  configure :request do
    # set :log_level, ENV["web.request.log_level"]

  end

end
