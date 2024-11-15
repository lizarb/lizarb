class NetSystem::ClientGeneratorTest < DevSystem::SimpleGeneratorTest
  
  # 

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::ClientGenerator
    assert_equality subject.class, NetSystem::ClientGenerator
  end
  
  test_erbs_defined(
    "controller.rb.erb",
    "test.rb.erb"
  )
  
end
