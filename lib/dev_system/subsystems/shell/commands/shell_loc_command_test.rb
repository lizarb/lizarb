class DevSystem::ShellLocCommandTest < DevSystem::SimpleCommandTest
  
  # 

  test :subject_class, :subject do
    assert_equality DevSystem::ShellLocCommand, subject_class
    assert_equality DevSystem::ShellLocCommand, subject.class
  end
  
end
