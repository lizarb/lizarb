class ArtSystem::OpenaiShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, ArtSystem::OpenaiShell
    assert_equality subject.class, ArtSystem::OpenaiShell
  end

end
