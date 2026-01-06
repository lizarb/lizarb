class DevSystem::PryCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::PryCommand
  end

end
