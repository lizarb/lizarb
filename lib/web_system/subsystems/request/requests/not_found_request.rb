class WebSystem::NotFoundRequest < WebSystem::Request

  def self.call menv
    super
    menv[:response_status] = 404
    menv[:response_headers] = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }
    menv[:response_body] = "Client Error #{menv[:response_status]} - #{menv["LIZA_PATH"]}"

    menv
  end

end
