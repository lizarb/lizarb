class DevSystem::AppShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::AppShell
  end

  test :writable_systems do
    a = subject_class.writable_systems.keys
    b = [:dev, :happy, :net, :web, :work, :micro, :desk, :crypto, :media, :art, :deep, :prime, :lab, :eco]
    assert_equality a, b
  end

  test :subject do
    system_keys = ["dev", "happy", "net", "web", "work", "micro", "desk", "crypto", "media", "art", "deep", "prime", "lab", "eco"]
    assert_equality subject.consts.keys,           [:top_level, :liza, :systems, :app]
    assert_equality subject.consts[:top_level],    [Lizarb, App, Liza]
    assert_equality subject.consts[:liza].keys,    ["unit", "helper_units", "systemic_units", "subsystemic_units", "ruby_tests"]
    assert_equality subject.consts[:systems].keys, system_keys
    assert_equality subject.consts[:app].keys,     system_keys
  end

  test :get_liza_categories do
    assert_equality subject.get_liza_categories.count, 5
  end

  test :others do
    assert_no_raise do
      subject.sorted_units
      subject.sorted_writable_units
      subject.sorted_writable_units_in_systems
    end
  end

  test :filters do
    assert_equality subject.filter_history.count, 0
    c0 = subject.get_units.count
    subject.filter_by_systems :dev
    assert_lt subject.get_units.count, c0
    assert_equality subject.filter_history.count, 1

    c1 = subject.get_units.count
    subject.filter_by_starting_with "gene"
    assert_lt subject.get_units.count, c1
    assert_equality subject.filter_history.count, 2

    subject.undo_filter!
    assert_equality subject.get_units.count, c1
    assert_equality subject.filter_history.count, 1

    subject.undo_filter!
    assert_equality subject.get_units.count, c0
    assert_equality subject.filter_history.count, 0
  end

end
