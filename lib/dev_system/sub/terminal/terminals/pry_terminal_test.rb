class DevSystem::PryTerminalTest < DevSystem::TerminalTest

  test :subject_class do
    assert subject_class == DevSystem::PryTerminal
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
