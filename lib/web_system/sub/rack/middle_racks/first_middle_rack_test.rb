class WebSystem::FirstMiddleRackTest < WebSystem::MiddleRackTest

  test :subject_class do
    assert subject_class == WebSystem::FirstMiddleRack
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

end
