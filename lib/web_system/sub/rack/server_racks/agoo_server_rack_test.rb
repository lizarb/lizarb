class WebSystem::AgooServerRackTest < WebSystem::ServerRackTest

  test :subject_class do
    assert subject_class == WebSystem::AgooServerRack
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

end
