class DevSystem::MoveGeneratorTest < DevSystem::SimpleGeneratorTest
  
  test :subject_class, :subject do
    assert_equality DevSystem::MoveGenerator, subject_class
    assert_equality DevSystem::MoveGenerator, subject.class
  end
  
end
