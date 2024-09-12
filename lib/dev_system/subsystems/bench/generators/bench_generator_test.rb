class DevSystem::BenchGeneratorTest < DevSystem::SimpleGeneratorTest

  #
  
  test :subject do
    assert_equality DevSystem::BenchGenerator, subject_class
    assert_equality DevSystem::BenchGenerator, subject.class
  end
  
end
