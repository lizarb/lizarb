class WebSystem::RequestPanel < Liza::Panel
  class Error < StandardError; end
  class RequestNotFound < Error; end

  def call env, allow_raise: false
    t = Time.now
    request_klass = find env
    ret = request_klass.call env
    _format env, ret
    log "#{ret[0]} with #{ret[2].first.size} bytes in #{t.diff}s"
    puts
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

  def find env
    _prepare env

    segments = env["LIZA_SEGMENTS"].dup
    request = segments.shift || "root"
    action  = segments.shift || "index"

    env["LIZA_REQUEST"] = request
    env["LIZA_ACTION"] = action
    format = env["LIZA_FORMAT"]

    log({request:, action:, format:})

    env["LIZA_REQUEST_CLASS"] = _find_request_class request
  end

  def _find_request_class request
    Liza.const "#{request}_request"
  rescue Liza::ConstNotFound
    raise RequestNotFound
  end

  #

  def _format env, ret
    format = env["LIZA_FORMAT"]

    body = ret[2][0]
    body = DevBox.format format, body
    ret[2][0] = body
  end

  def _prepare env
    log "#{env["REQUEST_METHOD"]} #{env["REQUEST_PATH"]}"

    path = env["REQUEST_PATH"]

    path, _sep, format = path.lpartition "."
    format = "html" if format.empty?

    segments = Array path.split("/")[1..-1]

    env["LIZA_PATH"]     = path
    env["LIZA_FORMAT"]   = format
    env["LIZA_SEGMENTS"] = segments
  end

end
