class DevSystem::BaseCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::BaseCommand
  end

end
