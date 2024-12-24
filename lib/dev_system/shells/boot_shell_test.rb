class DevSystem::BootShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::BootShell
    assert_equality subject.class, DevSystem::BootShell
  end

  test :loaders do
    assert_equality subject_class.core_loader.class, Zeitwerk::Loader
    assert_equality subject_class.app_loader.class,  Zeitwerk::Loader
  end

end
