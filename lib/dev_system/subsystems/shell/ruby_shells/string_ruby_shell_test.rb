class DevSystem::StringRubyShellTest < DevSystem::RubyShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::StringRubyShell
    assert_equality subject.class, DevSystem::StringRubyShell
  end

end
