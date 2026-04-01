class DevSystem::ZlibGemShellTest < DevSystem::GemShellTest
  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::ZlibGemShell
    assert_equality subject.class, DevSystem::ZlibGemShell
  end

end
