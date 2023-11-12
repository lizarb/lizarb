class DevSystem::GeneratorPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::GeneratorPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :call,
      :find,
      :forward, :forward_base_generator, :forward_generator,
      :inform,
      :parse,
      :save
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end
  
  #
  
  test :parse, true, :default do
    env = {args: ["system"]}
    subject.parse env
    assert_equality env[:generator_name_original], :system
    assert_equality env[:generator_name], :system
    assert_equality env[:generator_coil_original], nil
    assert_equality env[:generator_coil], :default
  end
  
  test :parse, true, :coil do
    env = {args: ["system:install"]}
    subject.parse env
    assert_equality env[:args], ["system:install"]
    assert_equality env[:generator_name_original], :system
    assert_equality env[:generator_name], :system
    assert_equality env[:generator_coil_original], :install
    assert_equality env[:generator_coil], :install
  end
  
  test :parse, false, :default do
    env = {args: ["x"]}
    subject.parse env
    assert_equality env[:args], ["x"]
    assert_equality env[:generator_name_original], :x
    assert_equality env[:generator_name], :x
    assert_equality env[:generator_coil_original], nil
    assert_equality env[:generator_coil], :default
  end
  
  test :parse, false, :coil do
    env = {args: ["x:y"]}
    subject.parse env
    assert_equality env[:args], ["x:y"]
    assert_equality env[:generator_name_original], :x
    assert_equality env[:generator_name], :x
    assert_equality env[:generator_coil_original], :y
    assert_equality env[:generator_coil], :y
  end
  
  #
  
  test :find, true do
    env = {generator_name: :command}
    subject.find env
    assert_equality env[:generator_class], CommandGenerator
  end
  
  test :find, false do
    env = {generator_name: :x}
    subject.find env
    assert false
  rescue DevSystem::GeneratorPanel::NotFoundError
    assert true  
  end

end
