class DevSystem::OverwriteGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert_equality DevSystem::OverwriteGenerator, subject_class
    assert_equality DevSystem::OverwriteGenerator, subject.class
  end

end
