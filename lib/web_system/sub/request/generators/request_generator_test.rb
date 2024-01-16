class WebSystem::RequestGeneratorTest < DevSystem::SimpleGeneratorTest

  test :subject_class do
    assert subject_class == WebSystem::RequestGenerator
  end

end
