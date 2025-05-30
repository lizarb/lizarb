class DevSystem::KernelShellTest < DevSystem::ShellTest
  
  # 
  
  test :subject_class, :subject do
    assert_equality DevSystem::KernelShell, subject_class
    assert_equality DevSystem::KernelShell, subject.class
  end

end
