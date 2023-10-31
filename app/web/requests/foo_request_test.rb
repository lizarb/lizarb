class FooRequestTest < WebSystem::SimpleRequestTest

  test :subject_class do
    assert subject_class == FooRequest
  end

  test :actions, :root do
    env = {
      "LIZA_ACTION" => "index",
    }

    status, headers, body = subject_class.call env

    assert status == 200
    assert headers["Framework"].to_s.start_with? "Liza"
    assert body.first.include? "<h1>Ruby Works"
  end

  test :actions, :other do
    env = {
      "LIZA_ACTION" => "other",
    }

    status, headers, body = subject_class.call env

    assert status == 404
    assert headers["Framework"].to_s.start_with? "Liza"
    assert body.first.include? "couldn't find your page"
  end

end
