class DevSystem::TypographyShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::TypographyShell
    assert_equality subject.class, DevSystem::TypographyShell
  end

end
