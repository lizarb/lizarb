class DevSystem::ObjectSpaceShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::ObjectSpaceShell
    assert_equality subject.class, DevSystem::ObjectSpaceShell
  end

end
