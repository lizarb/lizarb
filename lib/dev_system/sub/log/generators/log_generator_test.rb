class DevSystem::LogGeneratorTest < DevSystem::SimpleGeneratorTest

  #
  
  test :subject do
    assert_equality DevSystem::LogGenerator, subject_class
    assert_equality DevSystem::LogGenerator, subject.class
  end
  
end
