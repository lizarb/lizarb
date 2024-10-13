class DevSystem::ShellClocCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ShellClocCommand, subject_class
    assert_equality DevSystem::ShellClocCommand, subject.class
  end
  
end
