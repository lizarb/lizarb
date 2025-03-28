class WebSystem::SimpleRouterRequestTest < WebSystem::RouterRequestTest

  test :subject_class do
    assert subject_class == WebSystem::SimpleRouterRequest
  end

  test :path_for do
    assert_equality subject_class.path_for(:simple, :index), "/simple"
    assert_equality subject_class.path_for(:simple, :foo), "/simple/foo"
    assert_raises Liza::ConstNotFound do
      subject_class.path_for(:thiswontbefound, :foo)
    end
  end

end
