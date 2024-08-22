class DevSystem::GemfileGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::GemfileGenerator
  end

end
