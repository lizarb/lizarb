class DevSystem::NoneLogTest < DevSystem::LogTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::NoneLog, subject_class
    assert_equality DevSystem::NoneLog, subject.class
  end
  
end
