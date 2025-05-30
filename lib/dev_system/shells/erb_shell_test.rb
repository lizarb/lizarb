class DevSystem::ErbShellTest < DevSystem::ShellTest



  test :subject_class, :subject do
    assert_equality DevSystem::ErbShell, subject_class
    assert_equality DevSystem::ErbShell, subject.class
  end

end
