class Liza::SystemTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::System
  end

  test_methods_defined do
    on_self :box, :box?, :color, :const, :insertion, :registrar, :sub, :subs, :token
    on_instance
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :white
  end

end
