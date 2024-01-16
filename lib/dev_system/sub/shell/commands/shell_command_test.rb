class DevSystem::ShellCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::ShellCommand
  end

end
