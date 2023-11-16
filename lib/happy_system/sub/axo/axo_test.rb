class HappySystem::AxoTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == HappySystem::Axo
  end

  test_methods_defined do
    on_self :call
    on_instance :env, :env=
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
