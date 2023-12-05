class DevSystem::ConvertCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ConvertCommand, subject_class
    assert_equality DevSystem::ConvertCommand, subject.class
  end
  
end
