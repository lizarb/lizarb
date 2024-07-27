class Liza::ControllerTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Controller
  end

  test_methods_defined do
    on_self :box, \
      :color,
      :division!, :division?,
      :inherited,
      :on_connected,
      :panel, :plural,
      :puts,
      :singular,
      :subsystem, :subsystem!, :subsystem?,
      :token
    on_instance :box, :panel
  end

  test :erbs_defined do
    erbs_defined = subject_class.erbs_defined.map(&:key)
    expected = []
    assert_equality erbs_defined, expected
  end

  test :erbs_available do
    erbs_available = subject_class.erbs_available.map(&:key)
    expected = []
    assert_equality erbs_available, expected
  end

end
