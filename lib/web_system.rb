class WebSystem < Liza::System
  class Error < Error; end

  require "uri"

  color :dark_cerulean

  sub :rack
  sub :request

end
