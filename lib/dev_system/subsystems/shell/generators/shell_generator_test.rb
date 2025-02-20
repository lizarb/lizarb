class DevSystem::ShellGeneratorTest < DevSystem::SimpleGeneratorTest
  
  # 
  
  test :subject do
    assert_equality subject_class, DevSystem::ShellGenerator
    assert_equality subject.class, DevSystem::ShellGenerator
  end
  
  test_erbs_defined(
    "actions.rb.erb",
    "converter.rb.erb",
    "formatter.rb.erb", 
    "helpers.rb.erb",
    "instance.rb.erb",
    "renderer.rb.erb",
    "test.rb.erb",
    "view_simple.txt.erb"
  )
  
end
