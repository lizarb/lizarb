class WebSystem
  class RequestCommand < Liza::Command

    def self.call args
      log "args #{args}"

      if args.count < 2
        log "USAGE:"
        puts
        log "liza request get /"
        log "liza request post /path.json"
        return
      end

      env = {}
      env["REQUEST_METHOD"] = args[0].upcase
      env["REQUEST_PATH"]   = args[1..-1].join " "

      status, headers, body = Liza.const(:web_box).requests.call env

      log "STATUS #{status} with #{headers.count} headers and a #{body.first.size} byte body"

      puts status
      puts headers.map { |k, v| "#{k}: #{v}" }
      puts
      puts body.first
    end

  end
end
