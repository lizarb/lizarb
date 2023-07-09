class Liza::BoxTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Box
  end

  test_methods_defined do
    on_self :[], :configure, :controllers, :inherited, :panels, :puts
    on_instance
  end

  def assert_sub name, controller_class, panel_class, kaller: caller
    assert_equality subject_class[name].class, panel_class, kaller: kaller
    assert_equality subject_class.controllers[name], controller_class, kaller: kaller
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :white
  end

end
