class DevSystem::CommandGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == DevSystem::CommandGenerator
  end

end
