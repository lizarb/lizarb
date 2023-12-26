class WebSystem < Liza::System
  class Error < Error; end

  require "uri"

  color :dark_cerulean

  panel :rack
  panel :request

end
