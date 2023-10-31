class DevSystem::ConverterShellTest < DevSystem::ShellTest

  test :subject_class do
    assert subject_class == DevSystem::ConverterShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0

    assert_equality subject_class.token, :converter
    assert_equality subject_class.singular, :converter_shell
    assert_equality subject_class.plural, :converter_shells
  
    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Shell
    assert_equality subject_class.division, DevSystem::ConverterShell
  end

end
