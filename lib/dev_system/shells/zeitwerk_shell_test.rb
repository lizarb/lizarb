class DevSystem::ZeitwerkShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::ZeitwerkShell
    assert_equality subject.class, DevSystem::ZeitwerkShell
  end

  test :get_units_in_core do
    assert_equality subject_class.get_units_in_core.count, 22
  end

end
