class DevSystem::TtyPromptGemShellTest < DevSystem::GemShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::TtyPromptGemShell
    assert_equality subject.class, DevSystem::TtyPromptGemShell
  end

end
