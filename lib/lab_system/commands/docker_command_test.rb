class LabSystem::DockerCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert_equality subject_class, LabSystem::DockerCommand
  end

end
