class DevSystem::OverrideGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert_equality DevSystem::OverrideGenerator, subject_class
    assert_equality DevSystem::OverrideGenerator, subject.class
  end

end
