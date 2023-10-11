class WebBox < WebSystem::WebBox

  # Configure your rack panel

  configure :rack do
    # server (pick one, check gemfile)
    # server :agoo
    # server :falcon
    # server :iodine
    server :puma
    # server :thin

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000
  end

  # Configure your request panel

  configure :request do
    router :simple
  end

end
