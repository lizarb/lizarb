class DevSystem::BenchGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::BenchGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
