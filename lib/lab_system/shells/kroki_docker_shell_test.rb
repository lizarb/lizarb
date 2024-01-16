class LabSystem::KrokiDockerShellTest < LabSystem::DockerShellTest

  test :subject_class do
    assert_equality subject_class, LabSystem::KrokiDockerShell
  end

end
