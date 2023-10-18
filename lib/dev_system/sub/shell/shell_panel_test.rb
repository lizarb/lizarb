class DevSystem::ShellPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::ShellPanel
  end

  test_methods_defined do
    on_self
    on_instance
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
