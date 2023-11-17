class WebSystem::RequestGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == WebSystem::RequestGenerator
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
