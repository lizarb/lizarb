class WebSystem::WebBox < Liza::Box

  # Preconfigure your rack panel

  configure :rack do
    # set :log_level, ENV["web.rack.log_level"]

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000
  end

  # Preconfigure your request panel

  configure :request do
    # set :log_level, ENV["web.request.log_level"]

  end

end
