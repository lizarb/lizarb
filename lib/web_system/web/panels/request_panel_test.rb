class WebSystem::RequestPanelTest < Liza::PanelTest

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

  #

  test :_prepare do
    subject = WebSystem::WebBox.requests
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
