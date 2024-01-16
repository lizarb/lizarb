class WebSystem::FirstMiddleRackTest < WebSystem::MiddleRackTest

  test :subject_class do
    assert subject_class == WebSystem::FirstMiddleRack
  end

end
