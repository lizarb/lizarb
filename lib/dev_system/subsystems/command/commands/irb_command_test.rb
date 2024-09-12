class DevSystem::IrbCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::IrbCommand
  end

end
