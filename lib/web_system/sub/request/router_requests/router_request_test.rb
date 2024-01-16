class WebSystem::RouterRequestTest < WebSystem::RequestTest

  test :subject_class do
    assert subject_class == WebSystem::RouterRequest
  end

end
