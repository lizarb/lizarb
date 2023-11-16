class HappySystem::AxoPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == HappySystem::AxoPanel
  end

  test_methods_defined do
    on_self
    on_instance :call
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end
  
end
