class Liza::SystemTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::System
  end

  test_methods_defined do
    on_self :box, :color, :const, :insertion, :registrar, :sub, :subs, :token
    on_instance
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
