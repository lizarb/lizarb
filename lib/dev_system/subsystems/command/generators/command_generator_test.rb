class DevSystem::CommandGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert_equality subject_class, DevSystem::CommandGenerator
    assert_equality subject.class, DevSystem::CommandGenerator
  end

  test_erbs_defined(
    "section_base.rb.erb",
    "section_simple_actions.rb.erb",
    "section_simple_filters.rb.erb",
    "view_simple.txt.erb"
  )

end
