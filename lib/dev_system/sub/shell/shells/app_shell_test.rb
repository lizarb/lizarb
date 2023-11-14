class DevSystem::AppShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::AppShell
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :writable_systems do
    a = subject_class.writable_systems.keys
    b = [:dev, :happy, :net, :web, :work, :micro, :desk, :crypto, :art, :deep, :lab]
    assert_equality a, b
  end

end
