class ApiRequestTest < AppRequestTest

  test :subject_class do
    assert subject_class == ApiRequest
  end

  test :actions, :root do
    env = {
      "REQUEST_PATH" => "/",
    }

    status, headers, body = subject_class.call env

    assert status == 404
    assert headers["Framework"].to_s.start_with? "Liza"
    assert body.first.include? "render_route_not_found"
  end

  test :actions, :sign_up do
    env = {
      "REQUEST_PATH" => "/api/auth/sign_up",
    }

    status, headers, body = subject_class.call env

    assert status == 200
    assert headers["Framework"].to_s.start_with? "Liza"
    assert body.first.include? "render_route_api_auth_sign_up"
  end

end
