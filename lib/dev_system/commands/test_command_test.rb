class DevSystem::TestCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::TestCommand
  end

end
