class DevSystem::InputShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::InputShell
    assert_equality subject.class, DevSystem::InputShell
  end

end

