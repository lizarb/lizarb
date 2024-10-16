class DevSystem::RemoveGeneratorTest < DevSystem::SimpleGeneratorTest
  
  test :subject_class, :subject do
    assert_equality DevSystem::RemoveGenerator, subject_class
    assert_equality DevSystem::RemoveGenerator, subject.class
  end
  
end
