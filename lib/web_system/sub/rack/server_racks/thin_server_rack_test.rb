class WebSystem::ThinServerRackTest < WebSystem::ServerRackTest

  test :subject_class do
    assert subject_class == WebSystem::ThinServerRack
  end

end
