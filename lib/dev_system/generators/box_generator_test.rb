class DevSystem::BoxGeneratorTest < DevSystem::SimpleGeneratorTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::BoxGenerator, subject_class
    assert_equality DevSystem::BoxGenerator, subject.class
  end
  
end
