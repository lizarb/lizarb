class DevSystem::HighlineInputTerminalTest < DevSystem::InputTerminalTest

  test :subject_class do
    assert subject_class == DevSystem::HighlineInputTerminal
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green

    assert_equality subject_class.token, :highline
    assert_equality subject_class.singular, :highline_input_terminal
    assert_equality subject_class.plural, :highline_input_terminals

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Terminal
    assert_equality subject_class.division, DevSystem::InputTerminal
  end

end
