class HappySystem::AxoGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == HappySystem::AxoGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
