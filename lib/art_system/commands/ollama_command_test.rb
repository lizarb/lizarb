class ArtSystem::OllamaCommandTest < DevSystem::SimpleCommandTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, ArtSystem::OllamaCommand
    assert_equality subject.class, ArtSystem::OllamaCommand
  end

end
