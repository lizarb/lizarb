class DevSystem::TtyInputCommandTest < DevSystem::InputCommandTest

  test :subject_class do
    assert subject_class == DevSystem::TtyInputCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, :tty
    assert_equality subject_class.singular, :tty_input_command
    assert_equality subject_class.plural, :tty_input_commands

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Command
    assert_equality subject_class.division, DevSystem::InputCommand
  end

end
