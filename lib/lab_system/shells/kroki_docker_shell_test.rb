class LabSystem::KrokiDockerShellTest < LabSystem::DockerShellTest

  test :subject_class do
    assert_equality subject_class, LabSystem::KrokiDockerShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
