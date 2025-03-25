class HappySystem::HappyBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == HappySystem::HappyBox
  end

  test_methods_defined do
    on_self
    on_instance
  end

  test :panels do
    a = subject_class.panels.keys
    b = [:axo, :linter]
    assert_equality a, b
    
    assert_sub :axo, HappySystem::Axo, HappySystem::AxoPanel
    assert_sub :linter, HappySystem::Linter, HappySystem::LinterPanel
  end

end
