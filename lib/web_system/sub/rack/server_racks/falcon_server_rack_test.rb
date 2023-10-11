class WebSystem::FalconServerRackTest < WebSystem::ServerRackTest

  test :subject_class do
    assert subject_class == WebSystem::FalconServerRack
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

end
