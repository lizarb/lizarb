class WebSystem::MiddleRackTest < WebSystem::RackTest

  test :subject_class do
    assert subject_class == WebSystem::MiddleRack
  end

end
