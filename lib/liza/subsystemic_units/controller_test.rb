class Liza::ControllerTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Controller
  end

  test_sections(
    :subsystem=>{
      :constants=>[],
      :class_methods=>[:on_connected, :inherited, :color, :sh, :`, :subsystem, :subsystem?, :subsystem!, :box, :panel, :division, :division?, :division!, :singular, :plural, :token],
      :instance_methods=>[:sh, :`, :box, :panel]
    },
    :callable=>{
      :constants=>[],
      :class_methods=>[:require, :call, :requirements, :log, :puts],
      :instance_methods=>[:log, :puts]
    },
  )

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
