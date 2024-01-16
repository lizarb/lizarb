class DevSystem::NotFoundCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::NotFoundCommand
  end

end
