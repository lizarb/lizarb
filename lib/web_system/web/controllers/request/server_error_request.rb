class WebSystem
  class ServerErrorRequest < Request

    def self.call env
      status = 500

      headers = {
        "Framework" => "Liza #{Lizarb::VERSION}"
      }

      e = env["LIZA_ERROR"]

      body = "Server Error #{status} - #{e.class} - #{e.message}"

      log status
      [status, headers, [body]]
    end

  end
end
