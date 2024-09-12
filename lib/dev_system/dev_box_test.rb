class DevSystem::DevBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == DevSystem::DevBox
  end

  test_methods_defined do
    on_self \
      :bench,
      :command,
      :convert,
      :format,
      :generate,
      :input,
      :logg,
      :pick_many, :pick_one
    on_instance
  end

  test :subsystems do
    a = subject_class.panels.keys
    b = [:bench, :command, :generator, :log, :shell]
    assert_equality a, b
    
    assert_sub :bench,     DevSystem::Bench,     DevSystem::BenchPanel
    assert_sub :command,   DevSystem::Command,   DevSystem::CommandPanel
    assert_sub :generator, DevSystem::Generator, DevSystem::GeneratorPanel
    assert_sub :log,       DevSystem::Log,       DevSystem::LogPanel
    assert_sub :shell,     DevSystem::Shell,     DevSystem::ShellPanel
  end

end
