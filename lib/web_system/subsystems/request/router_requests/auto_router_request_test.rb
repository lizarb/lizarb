class WebSystem::AutoRouterRequestTest < WebSystem::RouterRequestTest

  test :subject_class do
    assert subject_class == WebSystem::AutoRouterRequest
  end

  test :path_for do
    assert_equality subject_class.path_for(:auto, :index), "/auto"
    assert_equality subject_class.path_for(:auto, :foo), "/auto/foo"
    assert_raises Liza::ConstNotFound do
      subject_class.path_for(:thiswontbefound, :foo)
    end
  end

end
