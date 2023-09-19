class DevSystem::MethodShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::MethodShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  #

  test :subject, false do
    subject = subject_class.new FileShell, :abc
    assert false
  rescue DevSystem::MethodShell::NotFoundError
    assert true
  end

  test :subject, :method, :line, :line_location, :signature_has_single_parameter_named? do
    subject = subject_class.new FileShell, :touch
    assert_equality subject.method, FileShell.method(:touch)

    assert_equality subject.object, FileShell
    assert_equality subject.method_name, :touch

    assert_equality subject.line, "def self.touch path"
    assert_equality subject.line_location, "lib/dev_system/sub/shell/shells/file_shell.rb:45"

    assert subject.signature_has_single_parameter_named? :path
    refute subject.signature_has_single_parameter_named? :wrong
  end

end
