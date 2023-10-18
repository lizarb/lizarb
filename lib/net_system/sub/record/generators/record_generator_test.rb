class NetSystem::RecordGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == NetSystem::RecordGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
