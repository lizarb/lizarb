class Liza::ControllerRendererPartTest < Liza::Test

  test :subject_class do
    assert subject_class == Liza::ControllerRendererPart
  end

  test :settings do
    assert subject_class.get(:log_level) == :normal
    assert subject_class.get(:log_color) == :white
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :white

    assert subject_class.settings == {}
  end

end
