class DevSystem::SoftShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::SoftShell
    assert_equality subject.class, DevSystem::SoftShell
  end

end
