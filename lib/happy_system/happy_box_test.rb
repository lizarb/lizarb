class HappySystem::HappyBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == HappySystem::HappyBox
  end

  test_methods_defined do
    on_self
    on_instance
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :panels do
    a = subject_class.panels.keys
    b = [:axo]
    assert_equality a, b
    
    assert_sub :axo, HappySystem::Axo, HappySystem::AxoPanel
  end

end
