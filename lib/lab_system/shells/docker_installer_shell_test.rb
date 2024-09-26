class LabSystem::DockerInstallerShellTest < DevSystem::ShellTest
  
  # 

  test :subject_class, :subject do
    assert_equality LabSystem::DockerInstallerShell, subject_class
    assert_equality LabSystem::DockerInstallerShell, subject.class
  end
  
  # 

end
