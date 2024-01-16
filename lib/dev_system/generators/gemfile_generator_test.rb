class DevSystem::GemfileGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::GemfileGenerator
  end

end
