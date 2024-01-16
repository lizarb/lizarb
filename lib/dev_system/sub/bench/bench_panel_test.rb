class DevSystem::BenchPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::BenchPanel
  end

  test_methods_defined do
    on_self
    on_instance
  end

end
