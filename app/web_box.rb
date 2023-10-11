class WebBox < Liza::WebBox

  configure :rack do
    # Configure your rack panel per the DSL in http://guides.lizarb.org/panels/rack.html
    
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

  configure :request do
    # Configure your request panel per the DSL in http://guides.lizarb.org/panels/request.html

    router :simple
  end

end
