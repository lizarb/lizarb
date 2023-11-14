class DevSystem::ShellGeneratorTest < DevSystem::SimpleGeneratorTest
  
  # 
  
  test :subject do
    assert_equality DevSystem::ShellGenerator, subject_class
    assert_equality DevSystem::ShellGenerator, subject.class
  end
  
end
