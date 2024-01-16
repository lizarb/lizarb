class DevSystem::SimpleCommandTest < DevSystem::BaseCommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::SimpleCommand
  end

end
