class DevSystem::BoxesGeneratorTest < DevSystem::SimpleGeneratorTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::BoxesGenerator, subject_class
    assert_equality DevSystem::BoxesGenerator, subject.class
  end
  
  test_erbs_defined
  
end
