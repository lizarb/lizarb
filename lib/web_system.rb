require "uri"

class WebSystem < Liza::System
  set :log_color, :blue

  sub :rack
  sub :request

end
