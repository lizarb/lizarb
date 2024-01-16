class LabSystem::DockerCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert_equality subject_class, LabSystem::DockerCommand
  end

end
