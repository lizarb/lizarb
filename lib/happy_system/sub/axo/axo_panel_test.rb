class HappySystem::AxoPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == HappySystem::AxoPanel
  end

  test_methods_defined do
    on_self
    on_instance :call
  end
  
end
