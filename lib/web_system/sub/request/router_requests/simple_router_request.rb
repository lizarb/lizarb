class WebSystem::SimpleRouterRequest < WebSystem::RouterRequest
  class RequestNotFound < Error; end

  def self.call(env)
    segments = env["LIZA_SEGMENTS"].dup
    request = segments.shift || "root"
    action  = segments.shift || "index"

    env["LIZA_REQUEST"] = request
    env["LIZA_ACTION"] = action
    format = env["LIZA_FORMAT"]

    log({request:, action:, format:})
    
    env["LIZA_REQUEST_CLASS"] = _find_request_class request
  end

  def self._find_request_class request
    Liza.const "#{request}_request"
  rescue Liza::ConstNotFound
    raise RequestNotFound
  end

end
