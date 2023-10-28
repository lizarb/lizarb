class DevSystem::TerminalPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::TerminalPanel
  end

  test_methods_defined do
    on_self 
    on_instance :call, :default, :find, :pallet
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
