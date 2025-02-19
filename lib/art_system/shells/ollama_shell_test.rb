class ArtSystem::OllamaShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, ArtSystem::OllamaShell
    assert_equality subject.class, ArtSystem::OllamaShell
  end

end
