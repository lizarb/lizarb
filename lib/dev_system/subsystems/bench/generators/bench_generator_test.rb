class DevSystem::BenchGeneratorTest < DevSystem::SimpleGeneratorTest

  #
  
  test :subject do
    assert_equality subject_class, DevSystem::BenchGenerator
    assert_equality subject.class, DevSystem::BenchGenerator
  end

  test_erbs_defined(
    "marks.rb.erb",
    "setup.rb.erb"
  )

end
