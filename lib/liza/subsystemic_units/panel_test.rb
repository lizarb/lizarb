class Liza::PanelTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Panel
  end

  def subject
    @subject ||= subject_class.new "name"
  end

  test_sections(
    :subsystem=>{
      :constants=>[],
      :class_methods=>[:instance, :box, :controller, :division, :token, :subsystem, :color, :log, :puts],
      :instance_methods=>[:box, :controller, :division, :subsystem, :key, :initialize, :push, :started, :log, :puts]
    },
    :env=>{
      :constants=>[],
      :class_methods=>[:env],
      :instance_methods=>[:env]
    }
  )
  
  test :instance do
    assert_equality BenchPanel.instance, DevBox.panels[:bench]
  end

end
