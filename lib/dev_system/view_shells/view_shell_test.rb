class DevSystem::ViewShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::ViewShell
    assert_equality subject.class, DevSystem::ViewShell
  end

end
