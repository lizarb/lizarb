class DevSystem::LogGeneratorTest < DevSystem::SimpleGeneratorTest

  #
  
  test :subject do
    assert_equality subject_class, DevSystem::LogGenerator
    assert_equality subject.class, DevSystem::LogGenerator
  end
  
  test_erbs_defined(
    "controller_section_1.rb.erb",
    "controller_test_section_1.rb.erb",
    "handler_section_1.rb.erb",
    "handler_test_section_1.rb.erb"
  )
  
end
