class DevSystem::InputTerminalTest < DevSystem::TerminalTest

  test :subject_class do
    assert subject_class == DevSystem::InputTerminal
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green

    assert_equality subject_class.token, :input
    assert_equality subject_class.singular, :input_terminal
    assert_equality subject_class.plural, :input_terminals

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Terminal
    assert_equality subject_class.division, DevSystem::InputTerminal
  end

end
