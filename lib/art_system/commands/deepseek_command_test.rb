class ArtSystem::DeepseekCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, ArtSystem::DeepseekCommand
    assert_equality subject.class, ArtSystem::DeepseekCommand
  end

end
