class DevSystem::AppShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::AppShell
  end

  test :writable_systems do
    a = subject_class.writable_systems.keys
    b = [:dev, :happy, :net, :web, :work, :micro, :desk, :crypto, :media, :art, :deep, :prime, :lab, :eco]
    assert_equality a, b
  end

  test :get_writable_domains do
    expected = {
      :core=>"Core",
      :dev=>DevSystem,
      :happy=>HappySystem,
      :net=>NetSystem,
      :web=>WebSystem,
      :work=>WorkSystem,
      :micro=>MicroSystem,
      :desk=>DeskSystem,
      :crypto=>CryptoSystem,
      :media=>MediaSystem,
      :art=>ArtSystem,
      :deep=>DeepSystem,
      :prime=>PrimeSystem,
      :lab=>LabSystem,
      :eco=>EcoSystem,
      :app=>"App"
    }

    assert_equality subject_class.get_writable_domains, expected
  end

  test :subject do
    system_keys = ["dev", "happy", "net", "web", "work", "micro", "desk", "crypto", "media", "art", "deep", "prime", "lab", "eco"]
    assert_equality subject.consts.keys,           [:top_level, :liza, :systems, :app]
    assert_equality subject.consts[:top_level],    [Lizarb, App, Liza]
    assert_equality subject.consts[:liza].keys,    ["unit", "helper_units", "systemic_units", "subsystemic_units", "extra_tests"]
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

  test :domain, :layer do
    layers = subject.get_layers_for_core
    assert_gt layers.count, 0
    
    assert_equality layers[0].color, :white
    assert_equality layers[0].level, 1
    assert_equality layers[0].name, "top level"
    assert_equality layers[0].objects.count, 3
    assert_equality layers[0].path, "lib/"

    #

    layers = subject.get_layers_for_system DevSystem
    assert_gt layers.count, 0

    assert_equality layers[0].color, [0, 204, 0]
    assert_equality layers[0].level, 1
    assert_equality layers[0].name, "DevSystem"
    assert_equality layers[0].objects.count, 4
    assert_equality layers[0].path, "lib/dev_system"

    #
    
    layers = subject.get_layers_for_app
    assert_gt layers.count, 0

    assert_equality layers[0].color, [0, 204, 0]
    assert_equality layers[0].level, 1
    assert_equality layers[0].name, "App"
    assert_equality layers[0].objects.count, 0
    assert_equality layers[0].path, "app/"

  end

end
