class WebSystem::RequestPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, WebSystem::RequestPanel
    refute_equality subject, WebBox[:request]
  end

  test_methods_defined do
    on_self
    on_instance \
      :call, :call!,
      :find,
      :router, :routers
  end

  #

  test :call! do
    env = {}
    env["PATH_INFO"] = "/foo/bar/baz"
    status, _headers, _body = subject.call! env
    assert_equality status, 404
  end

  test :call do
    env = {}
    env["PATH_INFO"] = "/foo/bar/baz"
    status, _headers, body = subject.call env
    assert_equality status, 404
    assert_equality body, ["Client Error 404 - /foo/bar/baz"]
  end

  #

  test :_prepare do
    env = {}
    env["PATH_INFO"]   = "/foo/bar/baz"
    subject._prepare env
    assert_equality env, {
      "PATH_INFO"=>"/foo/bar/baz",
      "LIZA_PATH"=>"/foo/bar/baz",
      "LIZA_FORMAT"=>"html",
      "LIZA_SEGMENTS"=>["foo", "bar", "baz"]
    }

    env = {}
    env["PATH_INFO"]   = "/"
    subject._prepare env
    assert_equality env, {
      "PATH_INFO"=>"/",
      "LIZA_PATH"=>"/",
      "LIZA_FORMAT"=>"html",
      "LIZA_SEGMENTS"=>[]
    }
  end

  test :find, :invalid do
    env = {}
    env["PATH_INFO"]   = "/foo/bar/baz"
    request_class = subject.find env
    assert_equality subject.routers.keys, []
    assert_equality request_class, WebSystem::NotFoundRequest
  end

  test :find, :valid do
    env = {}
    env["PATH_INFO"]   = "/"
    subject.router :simple
    assert_equality subject.routers.keys, [:simple]
    request_class = subject.find env
    assert_equality request_class, RootRequest
  end

  test :router do
    todo "write this"
  end

  test :routers do
    todo "write this"
  end

end
