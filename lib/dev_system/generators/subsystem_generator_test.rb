class DevSystem::SubsystemGeneratorTest < DevSystem::SimpleGeneratorTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::SubsystemGenerator
    assert_equality subject.class, DevSystem::SubsystemGenerator
  end

  test_erbs_defined(
    "section_controller.rb.erb",
    "section_controller_test.rb.erb",
    "section_panel.rb.erb",
    "section_panel_test.rb.erb"
  )

end
