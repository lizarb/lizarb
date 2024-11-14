class DevSystem::EnvfileGeneratorTest < DevSystem::BaseGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::EnvfileGenerator
  end

  test_erbs_defined(
    "env.env.erb",
    "code.env.erb",
    "demo.env.erb",
    "blank.env.erb"
  )
  
end
