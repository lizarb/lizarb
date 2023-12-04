class WebSystem::WebBox < Liza::Box

  # Preconfigure your rack panel

  configure :rack do
    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000
  end

  # Preconfigure your request panel

  configure :request do
    router :simple
  end

end
