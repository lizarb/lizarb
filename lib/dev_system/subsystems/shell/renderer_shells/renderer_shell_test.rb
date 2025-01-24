class DevSystem::RendererShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::RendererShell
    assert_equality subject.class, DevSystem::RendererShell
  end

end
