class DevSystem::FormatCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::FormatCommand, subject_class
    assert_equality DevSystem::FormatCommand, subject.class
  end
  
end
