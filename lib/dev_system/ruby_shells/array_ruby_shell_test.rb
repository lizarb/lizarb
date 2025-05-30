class DevSystem::ArrayRubyShellTest < DevSystem::RubyShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::ArrayRubyShell
    assert_equality subject.class, DevSystem::ArrayRubyShell
  end

end
