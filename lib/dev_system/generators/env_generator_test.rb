class DevSystem::EnvGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::EnvGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
