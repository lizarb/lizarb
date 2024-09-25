class LabSystem::DockerInstallerShellTest < DevSystem::ShellTest
  
  # 

  test :subject_class, :subject do
    assert_equality LabSystem::DockerInstallerShell, subject_class
    assert_equality LabSystem::DockerInstallerShell, subject.class
  end
  
  # 

  test :subject_class, :sum do
    a = subject_class.sum 1, 2
    b = 3
    assert_equality a, b
  end
  
  # 

  test :subject_class, :sub do
    a = subject_class.sub 1, 2
    b = -1
    assert_equality a, b
  end
  
end
