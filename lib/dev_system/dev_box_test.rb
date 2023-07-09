class DevSystem::DevBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == DevSystem::DevBox
  end

  test_methods_defined do
    on_self \
      :command,
      :convert, :convert?, :converters, :converters_to,
      :format, :format?, :formatters,
      :input,
      :pick_one
    on_instance
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  test :subsystems do
    a = subject_class.panels.keys
    b = [:bench, :command, :generator, :log, :shell, :terminal]
    assert_equality a, b
    
    assert_sub :bench,     DevSystem::Bench,     DevSystem::BenchPanel
    assert_sub :command,   DevSystem::Command,   DevSystem::CommandPanel
    assert_sub :generator, DevSystem::Generator, DevSystem::GeneratorPanel
    assert_sub :log,       DevSystem::Log,       DevSystem::LogPanel
    assert_sub :shell,     DevSystem::Shell,     DevSystem::ShellPanel
    assert_sub :terminal,  DevSystem::Terminal,  DevSystem::TerminalPanel
  end

end
