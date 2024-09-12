class WebSystem::LastMiddleRackTest < WebSystem::MiddleRackTest

  test :subject_class do
    assert subject_class == WebSystem::LastMiddleRack
  end

end
