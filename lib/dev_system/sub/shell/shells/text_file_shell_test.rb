class DevSystem::TextFileShellTest < DevSystem::FileShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::TextFileShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
