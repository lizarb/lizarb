class NetSystem::RecordGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == NetSystem::RecordGenerator
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :red
  end

end
