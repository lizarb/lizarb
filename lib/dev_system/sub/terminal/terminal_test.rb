class DevSystem::TerminalTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Terminal
  end

  test_methods_defined do
    on_self
    on_instance
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, nil
    assert_equality subject_class.singular, :terminal
    assert_equality subject_class.plural, :terminals

    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Terminal
    assert_equality subject_class.division, DevSystem::Terminal
  end

end
