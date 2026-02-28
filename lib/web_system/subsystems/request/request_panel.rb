class WebSystem::RequestPanel < Liza::Panel

  def call menv, allow_raise: false
    t = Time.now
    log "#{menv["REQUEST_METHOD"]} #{menv["PATH_INFO"]}"

    request_klass = find menv
    request_klass.call menv

    ret = [menv[:response_status], menv[:response_headers], [menv[:response_body]]]
    log "#{ret[0]} with #{ret[2].first.size} bytes in #{time_diff t}s"
    ret
  rescue => e
    raise e if allow_raise
    request_klass = WebSystem::ServerErrorRequest
    menv["LIZA_ERROR"] = e

    ret = request_klass.call menv
    log "#{ret[0]} with #{ret[2].first.size} bytes in #{time_diff t}s"
    puts
    ret
  end

  def call! menv
    call menv, allow_raise: true
  end

  section :routers

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

  section :finders

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

  section :forgers

  # Forges a request microenvironment from a path_info string
  # Defines:
  #   "PATH_INFO"
  #   "REQUEST_METHOD"
  #   "QUERY_STRING"
  # Returns:
  #   Hash
  def forge(path_info, request_method: "GET", qs: nil, headers: {})
    path_info = "/" if path_info.empty?

    menv = headers.merge({
      "PATH_INFO" => path_info,
      "QUERY_STRING" => qs,
      "REQUEST_METHOD" => request_method,
    })
    log :high, "#{request_method} #{path_info}#{qs ? "?#{qs}" : ""} with headers #{headers.inspect}"
    menv
  end

  section :prepare

  # Prepares the request microenvironment
  # Needs:
  #   "PATH_INFO"
  # Defines:
  #   :request_path
  #   :request_segments
  #   :request_format
  def _prepare menv
    path = menv["PATH_INFO"]
    index = path.rindex(".")
    path, format = path[0...index], path[(index+1)..-1] if index
    format ||= "html"

    segments = Array path.split("/")[1..-1]

    menv[:request_path]     = menv["LIZA_PATH"]     = path
    menv[:request_segments] = menv["LIZA_SEGMENTS"] = segments
    menv[:request_format]   = menv["LIZA_FORMAT"]   = format
  end

end
