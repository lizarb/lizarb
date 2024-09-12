class WebSystem::ClientErrorRequest < WebSystem::Request

  def self.call env
    super
    status = 400

    headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    body = "Client Error #{status} - #{env["LIZA_PATH"]}"

    [status, headers, [body]]
  end

end
