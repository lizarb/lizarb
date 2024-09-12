class WebSystem::SimpleRequest < WebSystem::Request

  #
  
  def self.call env
    super
    new.call env
  end

  #

  attr_reader :env

  def call env
    @env = env
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
    
    [@status, @headers, [@body]]
  end

  #

  def _call_action
    return public_send "call_#{action}!" if http_method == "POST" and respond_to? "call_#{action}!"
    return public_send "call_#{action}"  if respond_to? "call_#{action}"

    response_404
  end

  def response_404
    @status = 404
    @body = "404"
  end
  
  # env

  def http_method
    env["REQUEST_METHOD"]
  end

  def request
    @request ||= env["LIZA_REQUEST"].to_sym
  end

  def action
    @action ||= env["LIZA_ACTION"].to_sym
  end

  def format
    @format ||= env["LIZA_FORMAT"].to_sym
  end

  def segments
    @segments ||= env["LIZA_SEGMENTS"]
  end

  def qs
    @qs ||= (env["QUERY_STRING"] || "").split("&").map { _1.split("=") }.to_h
  end

end

__END__

# view html.html.erb
<!DOCTYPE html>
<html lang="en">
  <%= render "head" %>
  <%= render "body" %>
</html>

# view head.html.erb
<head>
  <meta charset="UTF-8">
  <title><%= get :title %></title>
</head>

# view body.html.erb
<body>
  <%= render %>
</body>

# view index.html.erb
<h1><%= self.class %></h1>
<h2><%= action %></h2>
<p>http_method: <%= http_method %></p>
<p>request: <%= request %></p>
<p>action: <%= action %></p>
<p>format: <%= format %></p>
<p>qs: <%= qs %></p>
<p>segments: <%= segments %></p>
