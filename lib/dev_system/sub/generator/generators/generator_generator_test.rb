class DevSystem::GeneratorGeneratorTest < Liza::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::GeneratorGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
