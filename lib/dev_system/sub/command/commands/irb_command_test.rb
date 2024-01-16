class DevSystem::IrbCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::IrbCommand
  end

end
