class DevSystem::ShellCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::ShellCommand
  end

  test_methods_defined do
    on_self
    on_instance :call_default, :call_load_path, :color
  end

end
