class DevSystem::TestCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::TestCommand
    assert_equality subject.class, DevSystem::TestCommand
  end

end
