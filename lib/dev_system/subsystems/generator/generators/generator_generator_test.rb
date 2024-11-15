class DevSystem::GeneratorGeneratorTest < Liza::SimpleGeneratorTest

  test :subject_class do
    assert_equality subject_class, DevSystem::GeneratorGenerator
    assert_equality subject.class, DevSystem::GeneratorGenerator
  end

  test_erbs_defined(
    "section_controller_actions.rb.erb",
    "section_simple_actions.rb.erb",
    "view_controller_actions.rb.erb",
    "view_controller_views.txt.erb",
    "view_simple.txt.erb"
  )

end
