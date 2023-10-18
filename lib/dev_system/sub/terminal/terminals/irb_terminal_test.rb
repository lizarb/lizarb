class DevSystem::IrbTerminalTest < DevSystem::TerminalTest

  test :subject_class do
    assert subject_class == DevSystem::IrbTerminal
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
