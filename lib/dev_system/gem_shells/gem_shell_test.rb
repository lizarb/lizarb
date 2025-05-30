class DevSystem::GemShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::GemShell
    assert_equality subject.class, DevSystem::GemShell
  end

end
