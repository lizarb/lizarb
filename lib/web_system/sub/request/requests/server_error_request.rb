class WebSystem::ServerErrorRequest < WebSystem::Request

  def self.call env
    status = 500

    headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    e = env["LIZA_ERROR"]

    body = "Server Error #{status} - #{e.class} - #{e.message}"

    [status, headers, [body]]
  end

end
