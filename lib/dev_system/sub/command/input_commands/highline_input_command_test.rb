class DevSystem::HighlineInputCommandTest < DevSystem::InputCommandTest

  test :subject_class do
    assert subject_class == DevSystem::HighlineInputCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, :highline
    assert_equality subject_class.singular, :highline_input_command
    assert_equality subject_class.plural, :highline_input_commands

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Command
    assert_equality subject_class.division, DevSystem::InputCommand
  end

end
