class DevSystem::RubyShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::RubyShell
    assert_equality subject.class, DevSystem::RubyShell
  end

end
