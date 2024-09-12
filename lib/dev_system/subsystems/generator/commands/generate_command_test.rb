class DevSystem::GenerateCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::GenerateCommand
  end

end
