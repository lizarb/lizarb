class DevSystem::NewCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::NewCommand
  end

end
