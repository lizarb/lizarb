class WebSystem
  class RequestPanel < Liza::Panel

    def call env
      puts

      # 1. LOG GET /

      log "#{env["REQUEST_METHOD"]} #{env["REQUEST_PATH"]}"

      # 2. PREPARE env

      path = env["REQUEST_PATH"]

      path, _sep, format = path.lpartition "."
      format = "html" if format.empty?

      segments = Array path.split("/")[1..-1]

      case segments.count
      when 0
        request, action = "root", "root"
      when 1
        request, action = "root", segments[0]
      else
        request, action = segments[0..1]
      end

      env["LIZA_PATH"] = path
      env["LIZA_REQUEST"] = request
      env["LIZA_ACTION"] = action
      env["LIZA_FORMAT"] = format

      log({request:, action:, format:})

      # 3. FIND request

      begin
        request_klass = Liza.const "#{request}_request"
      rescue NameError
        request_klass = NotFoundRequest
      end

      # 4. CALL

      request_klass.call env
    rescue => e
      request_klass = ServerErrorRequest
      env["LIZA_ERROR"] = e

      request_klass.call env
    end

  end
end
