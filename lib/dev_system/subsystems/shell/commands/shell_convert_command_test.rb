class DevSystem::ShellConvertCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ShellConvertCommand, subject_class
    assert_equality DevSystem::ShellConvertCommand, subject.class
  end
  
end
