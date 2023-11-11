class DevSystem::ColorCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::ColorCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
