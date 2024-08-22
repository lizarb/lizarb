class DevSystem::ShellCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::ShellCommand
  end

end
