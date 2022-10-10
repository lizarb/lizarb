class WebSystem
  class ClientErrorRequest < Request

    def self.call env
      status = 400

      headers = {
        "Framework" => "Liza #{Lizarb::VERSION}"
      }

      body = "Client Error #{status} - #{env["LIZA_PATH"]}"

      log status
      [status, headers, [body]]
    end

  end
end
