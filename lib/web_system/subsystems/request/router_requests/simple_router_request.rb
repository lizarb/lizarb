class WebSystem::SimpleRouterRequest < WebSystem::RouterRequest
  class RequestNotFound < Error; end

  def self.call(menv)
    super
    segments = menv["LIZA_SEGMENTS"].dup
    request = segments.shift || "root"
    action  = segments.shift || "index"
    format = menv["LIZA_FORMAT"]

    log "request: #{request.inspect}, action: #{action.inspect}, format: #{format.inspect}"
    request_class = _find_request_class request
    
    menv["LIZA_REQUEST"] = request
    menv["LIZA_ACTION"] = action
    menv["LIZA_REQUEST_CLASS"] = request_class

    request_class
  end

  def self.path_for(request, action)
    request = Liza.const "#{request}_request" if request.is_a? Symbol
    action.to_sym == :index \
      ? "/#{ request.token }"
      : "/#{ request.token }/#{ action }"
  end

  def self._find_request_class request
    Liza.const "#{request}_request"
  rescue Liza::ConstNotFound
    raise RequestNotFound
  end

end
