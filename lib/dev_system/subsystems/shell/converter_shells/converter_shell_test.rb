class DevSystem::ConverterShellTest < DevSystem::ShellTest

  test :subject_class do
    assert subject_class == DevSystem::ConverterShell
  end

  test :settings do
    assert_equality subject_class.token, :converter
    assert_equality subject_class.singular, :converter_shell
    assert_equality subject_class.plural, :converter_shells
  
    assert_equality subject_class.system, DevSystem
    assert_equality subject_class.subsystem, DevSystem::Shell
    assert_equality subject_class.division, DevSystem::ConverterShell
  end

  def test_convert source, expectation
    convert_env = {convert_in: source}
    subject_class.call convert_env
    actual = convert_env[:convert_out]
    # expectation.strip!

    assert_equality actual, expectation
  end

end
