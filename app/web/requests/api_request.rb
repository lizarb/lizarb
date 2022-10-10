class ApiRequest < AppRequest

  def self.call env
    path = env["REQUEST_PATH"]

    #

    status = 200
    headers = {
      "Framework" => "Liza #{Lizarb::VERSION}"
    }
    body = ""

    #

    segments = Array path.split("/")[1..-1]

    case segments
    in "api", "auth", "sign_up"
      body = render_route_api_auth_sign_up
    in "api", "auth", "sign_in"
      body = render_route_api_auth_sign_in
    in "api", "auth", "account"
      body = render_route_api_auth_account
    in "api", "auth", "sign_out"
      body = render_route_api_auth_sign_out
    in "api", "users"
      body = render_route_api_users
    else
      status = 404
      body = render_route_not_found env["LIZA_PATH"]
    end

    log status
    [status, headers, [body]]
  end

  def self.render_route_api_auth_sign_up
    "route: render_route_api_auth_sign_up"
  end

  def self.render_route_api_auth_sign_in
    "route: render_route_api_auth_sign_in"
  end

  def self.render_route_api_auth_account
    "route: render_route_api_auth_account"
  end

  def self.render_route_api_auth_sign_out
    "route: render_route_api_auth_sign_out"
  end

  def self.render_route_api_users
    "route: render_route_api_users"
  end

  def self.render_route_not_found path
    "route: render_route_not_found #{path}"
  end
end
