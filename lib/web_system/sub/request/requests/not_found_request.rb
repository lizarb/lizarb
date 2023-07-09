class WebSystem::NotFoundRequest < WebSystem::Request

  def self.call env
    status = 404

    headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    body = "Client Error #{status} - #{env["LIZA_PATH"]}"

    [status, headers, [body]]
  end

end
