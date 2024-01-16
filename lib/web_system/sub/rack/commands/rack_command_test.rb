class WebSystem::RackCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == WebSystem::RackCommand
  end

end
