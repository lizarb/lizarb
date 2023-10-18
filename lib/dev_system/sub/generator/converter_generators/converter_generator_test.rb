class DevSystem::ConverterGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::ConverterGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, :converter
    assert_equality subject_class.singular, :converter_generator
    assert_equality subject_class.plural, :converter_generators
  
    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Generator
    assert_equality subject_class.division, DevSystem::ConverterGenerator
  end

end
