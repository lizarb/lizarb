class HappySystem::AxoTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == HappySystem::Axo
  end

  test_methods_defined do
    on_self :call
    on_instance
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :magenta
  end

end
