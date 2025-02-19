class ArtSystem::RubyOpenaiGemShellTest < DevSystem::GemShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, ArtSystem::RubyOpenaiGemShell
    assert_equality subject.class, ArtSystem::RubyOpenaiGemShell
  end

end
