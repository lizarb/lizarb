class DevSystem::ShellTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Shell
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  #

  test :subject_class, :windows? do
    original = subject_class.windows?
    subject_class.instance_variable_set(:@windows, true)
    assert subject_class.windows?
  ensure
    subject_class.instance_variable_set(:@windows, original)
  end

  test :subject_class, :unix? do
    original = subject_class.unix?
    subject_class.instance_variable_set(:@unix, true)
    assert subject_class.unix?
  ensure
    subject_class.instance_variable_set(:@unix, original)
  end

  test :subject_class, :linux? do
    original = subject_class.linux?
    subject_class.instance_variable_set(:@linux, true)
    assert subject_class.linux?
  ensure
    subject_class.instance_variable_set(:@linux, original)
  end

  test :subject_class, :mac? do
    original = subject_class.mac?
    subject_class.instance_variable_set(:@mac, true)
    assert subject_class.mac?
  ensure
    subject_class.instance_variable_set(:@mac, original)
  end

end
