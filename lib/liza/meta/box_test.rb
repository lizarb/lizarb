class Liza::BoxTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Box
  end

  test_methods_defined do
    on_self :[], :configure, :panels, :puts
    on_instance
  end

  def assert_sub name, controller_class, panel_class, kaller: caller
    assert_equality subject_class[name].class, panel_class, kaller: kaller
    assert_equality panel_class.controller, controller_class, kaller: kaller
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
