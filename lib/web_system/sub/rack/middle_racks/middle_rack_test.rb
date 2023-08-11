class WebSystem::MiddleRackTest < WebSystem::RackTest

  test :subject_class do
    assert subject_class == WebSystem::MiddleRack
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :blue
  end

end
