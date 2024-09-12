class DevSystem::NewCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::NewCommand
  end

end
