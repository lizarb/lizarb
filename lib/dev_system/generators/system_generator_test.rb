class DevSystem::SystemGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::SystemGenerator
  end

  test_erbs_defined(
    "section_app_box_settings.rb.erb",
    "section_system_box_settings.rb.erb",
    "section_system_box_test.rb.erb",
    "section_system_default.rb.erb",
    "section_system_info.rb.erb",
    "section_system_test.rb.erb",
    "unit.rb.erb"
  )

end
