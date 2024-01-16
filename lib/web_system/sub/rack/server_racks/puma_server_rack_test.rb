class WebSystem::PumaServerRackTest < WebSystem::ServerRackTest

  test :subject_class do
    assert subject_class == WebSystem::PumaServerRack
  end

end
