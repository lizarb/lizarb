class WebSystem::MiddleRackTest < WebSystem::RackTest

  test :subject_class do
    assert subject_class == WebSystem::MiddleRack
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
