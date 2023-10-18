class WebSystem::ServerRackTest < WebSystem::RackTest

  test :subject_class do
    assert subject_class == WebSystem::ServerRack
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
