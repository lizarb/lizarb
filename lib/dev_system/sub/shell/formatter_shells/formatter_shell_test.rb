class DevSystem::FormatterShellTest < DevSystem::ShellTest

  test :subject_class do
    assert subject_class == DevSystem::FormatterShell
  end

  test :settings do
    assert_equality subject_class.token, :formatter
    assert_equality subject_class.singular, :formatter_shell
    assert_equality subject_class.plural, :formatter_shells
  
    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Shell
    assert_equality subject_class.division, DevSystem::FormatterShell
  end

end
