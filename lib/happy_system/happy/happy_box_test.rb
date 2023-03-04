class HappySystem::HappyBoxTest < Liza::BoxTest

  test :subject_class do
    assert subject_class == HappySystem::HappyBox
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :magenta
  end

  test :panels do
    assert subject_class[:axo].is_a? HappySystem::AxoPanel
  end

end
