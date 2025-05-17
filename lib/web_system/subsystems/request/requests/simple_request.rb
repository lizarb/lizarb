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

    around

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
    self.response_status = 404
    self.response_body = "404"
  end

  def around
    log :high, "."
    before
    _call_action
    after
    log :high, "."
  rescue Exception => e
    raise unless defined? rescue_from
    rescue_from e
  end

  def before
    self.response_status = 200
    self.response_headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }
  end

  def after
    self.response_body ||=
      render format,
        action,
        format: format,
        converted: true,
        formatted: true
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
