class NetSystem::RecordGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class, :subject do
    assert_equality subject_class, NetSystem::RecordGenerator
    assert_equality subject.class, NetSystem::RecordGenerator
  end

  test_erbs_defined(
    "controller.rb.erb",
    "test.rb.erb"
  )
  
end
