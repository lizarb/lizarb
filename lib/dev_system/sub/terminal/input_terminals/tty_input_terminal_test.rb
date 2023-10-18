class DevSystem::TtyInputTerminalTest < DevSystem::InputTerminalTest

  test :subject_class do
    assert subject_class == DevSystem::TtyInputTerminal
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, :tty
    assert_equality subject_class.singular, :tty_input_terminal
    assert_equality subject_class.plural, :tty_input_terminals

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Terminal
    assert_equality subject_class.division, DevSystem::InputTerminal
  end

end
