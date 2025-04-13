class ApiRequestTest < AppRequestTest

  test :subject_class do
    assert subject_class == ApiRequest
  end

  test :actions, :root do
    menv = {
      "REQUEST_PATH" => "/",
    }

    subject_class.call menv

    assert menv[:response_status] == 404
    assert menv[:response_headers]["Framework"].to_s.start_with? "Liza"
    assert menv[:response_body].include? "render_route_not_found"
  end

  test :actions, :sign_up do
    menv = {
      "REQUEST_PATH" => "/api/auth/sign_up",
    }

    subject_class.call menv

    assert menv[:response_status] == 200
    assert menv[:response_headers]["Framework"].to_s.start_with? "Liza"
    assert menv[:response_body].include? "render_route_api_auth_sign_up"
  end

end
