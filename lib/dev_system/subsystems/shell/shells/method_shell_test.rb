class DevSystem::MethodShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::MethodShell
  end

  #

  test :subject, false do
    subject_class.new FileShell, :abc
    assert false
  rescue DevSystem::MethodShell::NotFoundError
    assert true
  end

  test :subject, :method, :line, :line_location, :signature_has_single_parameter_named? do
    subject = subject_class.new BaseGenerator, :call
    assert_equality subject.method, BaseGenerator.method(:call)

    assert_equality subject.object, BaseGenerator
    assert_equality subject.method_name, :call

    assert_equality subject.line, "def self.call(env)"
    assert_equality subject.line_location, "lib/dev_system/subsystems/generator/generators/base_generator.rb:5"

    assert subject.signature_has_single_parameter_named? :env
    refute subject.signature_has_single_parameter_named? :wrong
  end

end
