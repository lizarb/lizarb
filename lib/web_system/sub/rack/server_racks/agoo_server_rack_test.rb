class WebSystem::AgooServerRackTest < WebSystem::ServerRackTest

  test :subject_class do
    assert subject_class == WebSystem::AgooServerRack
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
