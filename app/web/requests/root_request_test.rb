class RootRequestTest < AppRequestTest

  test :subject_class do
    assert subject_class == RootRequest
  end

  test :actions, :root do
    menv = {
      "LIZA_ACTION" => "index",
    }

    subject_class.call menv
    assert menv[:response_status] == 200
    assert menv[:response_headers]["Framework"].to_s.start_with? "Liza"
    assert menv[:response_body].include? "<h1>Ruby Works"
  end

  test :actions, :other do
    menv = {
      "LIZA_ACTION" => "other",
    }

    subject_class.call menv
    assert menv[:response_status] == 404
    assert menv[:response_headers]["Framework"].to_s.start_with? "Liza"
    assert menv[:response_body].include? "couldn't find your page"
  end

end
