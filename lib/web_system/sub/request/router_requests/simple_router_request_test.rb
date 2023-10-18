class WebSystem::SimpleRouterRequestTest < WebSystem::RouterRequestTest

  test :subject_class do
    assert subject_class == WebSystem::SimpleRouterRequest
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
