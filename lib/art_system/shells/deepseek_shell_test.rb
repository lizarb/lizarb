class ArtSystem::DeepseekShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, ArtSystem::DeepseekShell
    assert_equality subject.class, ArtSystem::DeepseekShell
  end

end
