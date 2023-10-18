class DevSystem::LineDiffShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::LineDiffShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
