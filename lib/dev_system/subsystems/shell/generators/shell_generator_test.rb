class DevSystem::ShellGeneratorTest < DevSystem::SimpleGeneratorTest
  
  # 
  
  test :subject do
    assert_equality subject_class, DevSystem::ShellGenerator
    assert_equality subject.class, DevSystem::ShellGenerator
  end
  
  test_erbs_defined(
    "actions.rb.erb",
    "controller.rb.erb",
    "test.rb.erb"
  )
  
end
