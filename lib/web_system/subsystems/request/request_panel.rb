class WebSystem::RequestPanel < Liza::Panel

  def call menv, allow_raise: false
    t = Time.now
    log "#{menv["REQUEST_METHOD"]} #{menv["PATH_INFO"]}"

    request_klass = find menv
    request_klass.call menv

    ret = [menv[:response_status], menv[:response_headers], [menv[:response_body]]]
    log "#{ret[0]} with #{ret[2].first.size} bytes in #{t.diff}s"
    ret
  rescue => e
    raise e if allow_raise
    request_klass = WebSystem::ServerErrorRequest
    menv["LIZA_ERROR"] = e

    ret = request_klass.call menv
    log "#{ret[0]} with #{ret[2].first.size} bytes in #{t.diff}s"
    puts
    ret
  end

  def call! menv
    call menv, allow_raise: true
  end

  #

  def router(name, &block)
    _routers[name] ||= []
    _routers[name].push block if block_given?
  end

  def routers
    @routers ||= _routers.map do |name, blocks|
      router = Liza.const "#{name}_router_request"
      blocks.each do |block|
        router.instance_eval(&block)
      end
      [name, router]
    end.to_h
  end

  def _routers
    @_routers ||= {}
  end

  #

  def find menv
    _prepare menv

    routers.values.each do |router|
      request_class = router.call menv
      return request_class if request_class
    end

    NotFoundRequest
  end

  def path_for(request, action)
    routers.values.each do |router|
      path = router.path_for request, action
      return path if path
    end

    nil
  end

  #

  def _prepare menv
    path = menv["PATH_INFO"]
    path, _sep, format = path.lpartition "."
    format = "html" if format.empty?

    segments = Array path.split("/")[1..-1]

    menv["LIZA_PATH"]     = path
    menv["LIZA_FORMAT"]   = format
    menv["LIZA_SEGMENTS"] = segments
  end

end
