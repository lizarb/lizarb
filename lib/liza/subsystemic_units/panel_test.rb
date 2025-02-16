class Liza::PanelTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Panel
  end

  def subject
    @subject ||= subject_class.new "name"
  end

  test_methods_defined do
    on_self \
      :box,
      :color,
      :controller,
      :puts,
      :subsystem,
      :token
    on_instance \
      :box,
      :controller, :division,
      :key, :push,
      :rescue_from, :rescue_from_panel, :rescuers,
      :short, :started,
      :subsystem
  end

  #
  
  test :instance do
    assert_equality BenchPanel.instance, DevBox.panels[:bench]
  end

end
