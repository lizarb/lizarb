class DevSystem::LineDiffShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::LineDiffShell
  end

end
