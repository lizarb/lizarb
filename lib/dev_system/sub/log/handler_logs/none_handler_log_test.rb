class DevSystem::NoneHandlerLogTest < DevSystem::HandlerLogTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::NoneHandlerLog, subject_class
    assert_equality DevSystem::NoneHandlerLog, subject.class
  end
  
end
