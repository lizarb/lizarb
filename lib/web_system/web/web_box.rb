class WebSystem
  class WebBox < Liza::Box
    has_panel :rack, :rack
    has_controller :rack, :rack
    has_panel :request, :requests
    has_controller :request, :requests

    # Set up your rack panel per the DSL in http://guides.lizarb.org/panels/rack.html
    rack do
      # set :log_level, ENV["web.rack.log_level"]
      
      set :files, App.root.join("web_files")
      set :host, "localhost"
      set :port, 3000
    end

    # Set up your request panel per the DSL in http://guides.lizarb.org/panels/request.html
    requests do
      # set :log_level, ENV["web.request.log_level"]
    end

  end
end
