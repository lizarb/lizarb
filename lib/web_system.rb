class WebSystem < Liza::System
  class Error < Error; end

  require "uri"

  set :log_color, :blue
  color :dark_cerulean

  sub :rack
  sub :request

end
