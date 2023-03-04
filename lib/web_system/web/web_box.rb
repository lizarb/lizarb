class WebSystem::WebBox < Liza::Box

  # Set up your rack panel per the DSL in http://guides.lizarb.org/panels/rack.html
  panel :rack do
    # set :log_level, ENV["web.rack.log_level"]

    set :files, App.root.join("web_files")
    set :host, "localhost"
    set :port, 3000
  end

  # Set up your request panel per the DSL in http://guides.lizarb.org/panels/request.html
  panel :request do
    # set :log_level, ENV["web.request.log_level"]

  end

  has_controller :rack, :rack
  has_controller :request, :request
end
