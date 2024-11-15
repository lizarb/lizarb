class DevSystem::BaseGeneratorTest < DevSystem::GeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::BaseGenerator
  end

  test_erbs_defined(
  )
  
end
