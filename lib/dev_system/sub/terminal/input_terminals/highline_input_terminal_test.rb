class DevSystem::HighlineInputTerminalTest < DevSystem::InputTerminalTest

  test :subject_class do
    assert subject_class == DevSystem::HighlineInputTerminal
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

end
