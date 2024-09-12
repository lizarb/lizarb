class WebSystem::RackCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == WebSystem::RackCommand
  end

end
