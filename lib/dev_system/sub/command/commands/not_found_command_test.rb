class DevSystem::NotFoundCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::NotFoundCommand
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
