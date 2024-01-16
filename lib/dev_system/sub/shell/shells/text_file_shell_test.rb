class DevSystem::TextFileShellTest < DevSystem::FileShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::TextFileShell
  end

end
