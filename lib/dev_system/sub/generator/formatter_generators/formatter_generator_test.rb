class DevSystem::FormatterGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::FormatterGenerator
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green

    assert_equality subject_class.token, :formatter
    assert_equality subject_class.singular, :formatter_generator
    assert_equality subject_class.plural, :formatter_generators
  
    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Generator
    assert_equality subject_class.division, DevSystem::FormatterGenerator
  end

end
