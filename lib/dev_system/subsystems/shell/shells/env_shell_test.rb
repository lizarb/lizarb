class DevSystem::EnvShellTest < DevSystem::ShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::EnvShell
    assert_equality subject.class, DevSystem::EnvShell
  end

  test :optional do
    refute_equality nil, (subject_class.optional "BUNDLE_GEMFILE")
    refute_equality nil, (subject_class.optional "BUNDLE_GEMFILE", nil)
    assert_equality nil, (subject_class.optional "THIS_ENV_VAR_DOES_NOT_EXIST")
    assert_equality "A", (subject_class.optional "THIS_ENV_VAR_DOES_NOT_EXIST", "A")
  end

  test :mandatory do
    refute_equality nil, (subject_class.mandatory "BUNDLE_GEMFILE")
    assert_raises(
      DevSystem::EnvShell::MandatoryError,
      "Mandatory Environment Variable Not Found: THIS_ENV_VAR_DOES_NOT_EXIST. Your .env files are: []"
      ) do
      subject_class.mandatory "THIS_ENV_VAR_DOES_NOT_EXIST"
    end
  end

end
