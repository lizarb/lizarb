class DevSystem::InputCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::InputCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, :input
    assert_equality subject_class.singular, :input_command
    assert_equality subject_class.plural, :input_commands

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Command
    assert_equality subject_class.division, DevSystem::InputCommand
  end

end
