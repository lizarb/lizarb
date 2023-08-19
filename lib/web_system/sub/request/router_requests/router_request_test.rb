class WebSystem::RouterRequestTest < WebSystem::RequestTest

  test :subject_class do
    assert subject_class == WebSystem::RouterRequest
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

end
