class Liza::PanelTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Panel
  end

  def subject
    @subject ||= subject_class.new "name"
  end

  test_methods_defined do
    on_self :box, :inherited, :on_connected, :puts
    on_instance :box, :push, :short, :started
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :white
  end

  test :short do
    assert_equality subject.short("m"), "m"
    assert_equality subject.short("i"), "i"
    assert_equality subject.short("n"), "n"
    assert_equality subject.short("s"), "s"
    assert_equality subject.short("w"), "w"
    assert_equality subject.short("a"), "a"
    assert_equality subject.short("n"), "n"

    subject.short :m, :matz
    subject.short :i, :is
    subject.short :n, :nice
    subject.short :s, :so
    subject.short :w, :we
    subject.short :a, :are

    assert_equality subject.short("m"), "matz"
    assert_equality subject.short("i"), "is"
    assert_equality subject.short("n"), "nice"
    assert_equality subject.short("s"), "so"
    assert_equality subject.short("w"), "we"
    assert_equality subject.short("a"), "are"
    assert_equality subject.short("n"), "nice"
  end

end
