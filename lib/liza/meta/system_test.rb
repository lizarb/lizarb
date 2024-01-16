class Liza::SystemTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::System
  end

  test_methods_defined do
    on_self :box, :color, :const, :sub, :subs, :subsystems, :token
    on_instance
  end

end
