class DevSystem::NewGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::NewGenerator
  end

end
