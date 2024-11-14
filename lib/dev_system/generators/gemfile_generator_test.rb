class DevSystem::GemfileGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::GemfileGenerator
  end

  test_erbs_defined(
    "gemfile.rb.erb"
  )

end
