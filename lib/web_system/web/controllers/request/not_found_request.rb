class WebSystem
  class NotFoundRequest < Request

    def self.call env
      status = 404

      headers = {
        "Framework" => "Liza #{Lizarb::VERSION}"
      }

      body = "Client Error #{status} - #{env["LIZA_PATH"]}"

      log status
      [status, headers, [body]]
    end

  end
end
