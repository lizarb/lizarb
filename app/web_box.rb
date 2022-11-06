class WebBox < Liza::WebBox

  rack do
    # Set up your rack panel per the DSL in http://guides.lizarb.org/panels/rack.html
    
    # set :files, App.root.join("web_files")
    # set :host, "localhost"
    # set :port, 3000
  end

  requests do
    # Set up your request panel per the DSL in http://guides.lizarb.org/panels/request.html

  end

end
