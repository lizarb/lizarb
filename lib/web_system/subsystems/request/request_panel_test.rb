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
    menv = {}
    menv["PATH_INFO"] = "/foo/bar/baz"
    status, _headers, _body = subject.call! menv
    assert_equality status, 404
  end

  test :call do
    menv = {}
    menv["PATH_INFO"] = "/foo/bar/baz"
    status, _headers, body = subject.call menv
    assert_equality status, 404
    assert_equality body, ["Client Error 404 - /foo/bar/baz"]
  end

  #

  test :find, :invalid do
    menv = {}
    menv["PATH_INFO"]   = "/foo/bar/baz"
    request_class = subject.find menv
    assert_equality subject.routers.keys, []
    assert_equality request_class, WebSystem::NotFoundRequest
  end

  test :find, :valid do
    menv = {}
    menv["PATH_INFO"]   = "/"
    subject.router :simple
    assert_equality subject.routers.keys, [:simple]
    request_class = subject.find menv
    assert_equality request_class, RootRequest
  end

  def test_prepare(path_info, request_path:, request_segments:, request_format:)
    menv = {}
    menv["PATH_INFO"] = path_info
    subject._prepare menv
    assert_equality menv, {
      "PATH_INFO"=>path_info,
      "LIZA_PATH"=>request_path,
      request_path: request_path,
      "LIZA_SEGMENTS"=>request_segments,
      request_segments: request_segments,
      "LIZA_FORMAT"=>request_format,
      request_format: request_format,
    }
  end

  test :_prepare do
    test_prepare "/",
      request_path: "/",
      request_segments: [],
      request_format: "html"

    test_prepare "/.abc",
      request_path: "/",
      request_segments: [],
      request_format: "abc"

    test_prepare "/foo/bar/baz",
      request_path: "/foo/bar/baz",
      request_segments: ["foo", "bar", "baz"],
      request_format: "html"

    test_prepare "/foo/bar/baz.json",
      request_path: "/foo/bar/baz",
      request_segments: ["foo", "bar", "baz"],
      request_format: "json"

    test_prepare "/.well-known/appspecific/com.chrome.devtools.json",
      request_path: "/.well-known/appspecific/com.chrome.devtools",
      request_segments: [".well-known", "appspecific", "com.chrome.devtools"],
      request_format: "json"
  end

  test :path_for do
    todo "write this"
  end

  test :router do
    todo "write this"
  end

  test :routers do
    todo "write this"
  end

end
