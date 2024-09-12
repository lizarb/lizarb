class WebSystem::RackPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, WebSystem::RackPanel
    refute_equality subject, WebBox[:rack]
  end

  test_methods_defined do
    on_self
    on_instance :call, :rack_app, :server
  end

  test :call do
    todo "write this"
  end

  test :rack_app do
    todo "write this"
  end

  test :server do
    todo "write this"
  end

end
