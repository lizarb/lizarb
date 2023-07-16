class HappySystem::AxoPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == HappySystem::AxoPanel
  end

  test_methods_defined do
    on_self
    on_instance
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :magenta
  end
  
end
