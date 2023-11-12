class DevSystem::GenerateCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::GenerateCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
