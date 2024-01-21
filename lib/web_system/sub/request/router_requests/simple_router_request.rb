class WebSystem::SimpleRouterRequest < WebSystem::RouterRequest
  class RequestNotFound < Error; end

  def self.call(env)
    segments = env["LIZA_SEGMENTS"].dup
    request = segments.shift || "root"
    action  = segments.shift || "index"
    format = env["LIZA_FORMAT"]

    log({request:, action:, format:})
    request_class = _find_request_class request
    
    env["LIZA_REQUEST"] = request
    env["LIZA_ACTION"] = action
    env["LIZA_REQUEST_CLASS"] = request_class

    request_class
  end

  def self._find_request_class request
    Liza.const "#{request}_request"
  rescue Liza::ConstNotFound
    raise RequestNotFound
  end

end
