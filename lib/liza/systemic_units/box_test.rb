class Liza::BoxTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Box
  end

  test_methods_defined do
    on_self :[], :color, :configure, :forward, :panels, :puts
    on_instance
  end

  def assert_sub name, controller_class, panel_class, kaller: caller
    assert_equality subject_class[name].class, panel_class, kaller: kaller
    assert_equality panel_class.controller, controller_class, kaller: kaller
  end

  test :preconfiguration, :configuration do
    assert_equality ::DevBox.preconfiguration, ::DevSystem::DevBox
    assert_equality ::DevBox.configuration, ::DevBox
    assert_equality ::DevSystem::DevBox.preconfiguration, ::DevSystem::DevBox
    assert_equality ::DevSystem::DevBox.configuration, ::DevBox
  end

end
