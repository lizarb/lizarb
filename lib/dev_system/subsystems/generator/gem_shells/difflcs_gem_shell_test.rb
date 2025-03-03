class DevSystem::DifflcsGemShellTest < DevSystem::GemShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::DifflcsGemShell
    assert_equality subject.class, DevSystem::DifflcsGemShell
  end

end
