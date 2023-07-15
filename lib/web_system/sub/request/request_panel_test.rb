class WebSystem::RequestPanelTest < Liza::PanelTest

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

  #

  test :call! do
    subject = WebBox[:request]
    env = {}
    env["REQUEST_PATH"] = "/foo/bar/baz"
    subject.call! env
    assert false
  rescue => e
    assert_equality e.class, WebSystem::RequestPanel::RequestNotFound
    assert_equality e.cause.class, Liza::ConstNotFound
  end

  test :call do
    subject = WebBox[:request]
    env = {}
    env["REQUEST_PATH"] = "/foo/bar/baz"
    status, headers, body = subject.call env
    assert_equality status, 500
    assert_equality body.first, "Server Error 500 - WebSystem::RequestPanel::RequestNotFound - WebSystem::RequestPanel::RequestNotFound"
  end

  #

  test :_prepare do
    subject = WebBox[:request]
    env = {}
    env["REQUEST_PATH"]   = "/foo/bar/baz"
    subject._prepare env
    assert_equality env, {
      "REQUEST_PATH"=>"/foo/bar/baz",
      "LIZA_PATH"=>"/foo/bar/baz",
      "LIZA_FORMAT"=>"html",
      "LIZA_SEGMENTS"=>["foo", "bar", "baz"]
    }

    env = {}
    env["REQUEST_PATH"]   = "/"
    subject._prepare env
    assert_equality env, {
      "REQUEST_PATH"=>"/",
      "LIZA_PATH"=>"/",
      "LIZA_FORMAT"=>"html",
      "LIZA_SEGMENTS"=>[]
    }
  end

end
