class WebSystem::SimpleRequest < WebSystem::Request
  menv_accessor :response_status, :response_headers, :response_body
  #

  def self.call menv
    super
    new.call menv
  end

  #

  def call(menv)
    super
    @status = 200
    @headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }

    _call_action
    @body ||=
      render format,
        action,
        format: format,
        converted: true,
        formatted: true

    self.response_status = @status
    self.response_headers = @headers
    self.response_body = @body

    menv
  end

  #

  def _call_action
    return public_send "call_#{action}!" if http_method == "POST" and respond_to? "call_#{action}!"
    return public_send "call_#{action}"  if respond_to? "call_#{action}"

    return public_send "get_#{action}" if http_method == "GET" and respond_to? "get_#{action}"
    return public_send "post_#{action}" if http_method == "POST" and respond_to? "post_#{action}"

    response_404
  end

  def response_404
    @status = 404
    @body = "404"
  end

  # menv

  def env
    menv
  end

  def http_method
    menv["REQUEST_METHOD"]
  end

  def request
    @request ||= menv["LIZA_REQUEST"].to_sym
  end

  def action
    @action ||= menv["LIZA_ACTION"].to_sym
  end

  def format
    @format ||= menv["LIZA_FORMAT"].to_sym
  end

  def segments
    @segments ||= menv["LIZA_SEGMENTS"]
  end

  def qs
    @qs ||= (menv["QUERY_STRING"] || "").split("&").map { _1.split("=") }.to_h
  end

end
