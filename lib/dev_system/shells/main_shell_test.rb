class DevSystem::MainShellTest < DevSystem::ShellTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::MainShell, subject_class
    assert_equality DevSystem::MainShell, subject.class
  end
  
end
