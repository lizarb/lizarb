class DevSystem::SimpleCommandTest < DevSystem::BaseCommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::SimpleCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
