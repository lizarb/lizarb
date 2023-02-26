class Liza::PanelTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Panel
  end

  def subject
    subject_class.new "name"
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :white
  end
end
