class DevSystem::GeneratorGeneratorTest < Liza::GeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::GeneratorGenerator
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

end
