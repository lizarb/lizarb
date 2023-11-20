class ColorCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality ColorCommand, subject_class
    assert_equality ColorCommand, subject.class
  end
  
end
