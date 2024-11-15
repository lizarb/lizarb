class HappySystem::AxoGeneratorTest < DevSystem::ControllerGeneratorTest

  test :subject_class do
    assert_equality subject_class, HappySystem::AxoGenerator
    assert_equality subject.class, HappySystem::AxoGenerator
  end

  test_erbs_defined(
    "controller.rb.erb",
  )
  
end
