class WebSystem::SimpleRouterRequestTest < WebSystem::RouterRequestTest

  test :subject_class do
    assert subject_class == WebSystem::SimpleRouterRequest
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

end
