class WebBox < WebSystem::WebBox

  configure :rack do
    # RackPanel.instance gives you read-access to this instance
    # server (pick one, check gemfile)
    # server :agoo
    # server :falcon
    # server :iodine
    server :puma
    # server :thin

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 5000
  end

  configure :request do
    # RequestPanel.instance gives you read-access to this instance
    router :simple
  end

end
