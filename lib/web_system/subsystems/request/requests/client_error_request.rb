class WebSystem::ClientErrorRequest < WebSystem::Request

  def self.call(menv)
    super
    self.response_status = 400

    self.response_headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    self.response_body = "Client Error #{response_status} - #{menv["LIZA_PATH"]}"
  end

end
