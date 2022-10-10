class AssetsRequestTest < AppRequestTest

  test :subject_class do
    assert subject_class == AssetsRequest
  end

  test :actions, :app, :js do
    env = {
      "LIZA_ACTION" => "app",
      "LIZA_FORMAT" => "js",
    }

    status, headers, body = subject_class.call env

    assert status == 200
    assert headers["Framework"].to_s.start_with? "Liza"
    assert body.first.include? "JS file has been loaded"
  end

  test :actions, :app, :css do
    env = {
      "LIZA_ACTION" => "app",
      "LIZA_FORMAT" => "css",
    }

    status, headers, body = subject_class.call env

    assert status == 200
    assert headers["Framework"].to_s.start_with? "Liza"
    assert body.first.include? "body {"
  end

end
