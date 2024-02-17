class WebSystem::RequestPanel < Liza::Panel

  def call env, allow_raise: false
    t = Time.now
    log "#{env["REQUEST_METHOD"]} #{env["PATH_INFO"]}"

    request_klass = find env
    ret = request_klass.call env
    _format env, ret
    
    log "#{ret[0]} with #{ret[2].first.size} bytes in #{t.diff}s"
    ret
  rescue => e
    raise e if allow_raise
    request_klass = WebSystem::ServerErrorRequest
    env["LIZA_ERROR"] = e

    ret = request_klass.call env
    log "#{ret[0]} with #{ret[2].first.size} bytes in #{t.diff}s"
    puts
    ret
  end

  def call! env
    call env, allow_raise: true
  end

  #

  def router(name, &block)
    router = routers[name] ||= Liza.const "#{name}_router_request"
    router.instance_eval(&block) if block_given?
  end

  def routers
    @routers ||= {}
  end

  #

  def find env
    _prepare env

    routers.values.each do |router|
      request_class = router.call env
      return request_class if request_class
    end

    NotFoundRequest
  end

  #

  def _format env, ret
    format = env["LIZA_FORMAT"]

    body = ret[2][0]
    body = DevBox.format format, body
    ret[2][0] = body
  end

  def _prepare env
    path = env["PATH_INFO"]
    path, _sep, format = path.lpartition "."
    format = "html" if format.empty?

    segments = Array path.split("/")[1..-1]

    env["LIZA_PATH"]     = path
    env["LIZA_FORMAT"]   = format
    env["LIZA_SEGMENTS"] = segments
  end

end
