class WebSystem::RequestGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert_equality subject_class, WebSystem::RequestGenerator
    assert_equality subject.class, WebSystem::RequestGenerator
  end

  test_erbs_defined(
    "base.rb.erb",
    "simple_actions.rb.erb",
    "simple_view.html.erb",
    "test.rb.erb"
  )
  
end
