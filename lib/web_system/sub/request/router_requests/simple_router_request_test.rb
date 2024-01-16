class WebSystem::SimpleRouterRequestTest < WebSystem::RouterRequestTest

  test :subject_class do
    assert subject_class == WebSystem::SimpleRouterRequest
  end

end
