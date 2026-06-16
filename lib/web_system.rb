class WebSystem < Liza::System
  class Error < Error; end

  require "uri"

  color :dark_cerulean

  has_subsystem :rack
  has_subsystem :request

end
