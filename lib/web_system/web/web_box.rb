class WebSystem
  class WebBox < Liza::Box
    has_panel :request, :requests
    has_controller :request, :requests

    # Set up your request panel per the DSL in http://guides.lizarb.org/panels/request.html
    requests do
      # set :log_level, ENV["web.request.log_level"]
    end

  end
end
