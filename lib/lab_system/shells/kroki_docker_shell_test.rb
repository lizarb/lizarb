class LabSystem::KrokiDockerShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, LabSystem::KrokiDockerShell
  end

end
