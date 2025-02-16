class Liza::BoxTest < Liza::UnitTest
  test :subject_class do
    assert subject_class == Liza::Box
  end

  test_sections(
    :default=>{
      :constants=>[],
      :class_methods=>[:panels, :[]],
      :instance_methods=>[]
    },
    :two_boxes=>{
      :constants=>[],
      :class_methods=>[:preconfiguration, :configuration, :preconfigure, :configure],
      :instance_methods=>[]
    },
    :forwarding=>{
      :constants=>[],
      :class_methods=>[:forward, :color, :log, :puts],
      :instance_methods=>[:log, :puts]
    },
  )

  def assert_sub name, controller_class, panel_class, kaller: caller
    assert_equality subject_class[name].class, panel_class, kaller: kaller
    assert_equality panel_class.controller, controller_class, kaller: kaller
  end

  test :preconfiguration, :configuration do
    assert_equality ::DevBox.preconfiguration, ::DevSystem::DevBox
    assert_equality ::DevBox.configuration, ::DevBox
    assert_equality ::DevSystem::DevBox.preconfiguration, ::DevSystem::DevBox
    assert_equality ::DevSystem::DevBox.configuration, ::DevBox
  end

end
