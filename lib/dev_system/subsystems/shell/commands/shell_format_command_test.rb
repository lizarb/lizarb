class DevSystem::ShellFormatCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ShellFormatCommand, subject_class
    assert_equality DevSystem::ShellFormatCommand, subject.class
  end
  
end
