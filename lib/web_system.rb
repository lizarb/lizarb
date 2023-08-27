class WebSystem < Liza::System
  class Error < Error; end

  require "uri"

  set :log_color, :blue

  sub :rack
  sub :request

end
