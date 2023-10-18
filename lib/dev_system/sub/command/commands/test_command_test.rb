class DevSystem::TestCommandTest < DevSystem::CommandTest

  test :subject_class do
    assert subject_class == DevSystem::TestCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
