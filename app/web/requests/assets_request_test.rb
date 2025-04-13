class AssetsRequestTest < AppRequestTest

  test :subject_class do
    assert subject_class == AssetsRequest
  end

  test :actions, :app, :js do
    menv = {
      "LIZA_ACTION" => "app",
      "LIZA_FORMAT" => "js",
    }
    subject_class.call menv

    assert menv[:response_status]  == 200
    assert menv[:response_headers]["Framework"].to_s.start_with? "Liza"
    assert menv[:response_body].include? "JS file has been loaded"
  end

  test :actions, :app, :css do
      menv = {
      "LIZA_ACTION" => "app",
      "LIZA_FORMAT" => "css",
    }

    subject_class.call menv

    assert menv[:response_status]  == 200
    assert menv[:response_headers]["Framework"].to_s.start_with? "Liza"
    assert menv[:response_body].include? "body {"
  end

end
