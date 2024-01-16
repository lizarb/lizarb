class DevSystem::PryCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::PryCommand
  end

end
