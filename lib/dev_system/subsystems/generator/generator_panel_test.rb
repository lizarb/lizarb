class DevSystem::GeneratorPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::GeneratorPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :call,
      :find,
      :forward,
      :inform,
      :forge,
      :save
  end
  
  section :forge
  
  def forge_with(args)
    command = SimpleCommand.new
    command_env = {command: , args: }
    command.instance_variable_set :@env, command_env
    env = subject.forge command_env
    env
  end
  
  test :forge, true do
    env = forge_with ["system"]
    assert_equality env[:generator_name_original], "system"
    assert_equality env[:generator_name], "system"
    assert_equality env[:generator_action_original], nil
    assert_equality env[:generator_action], "default"
  end
  
  test :forge, true, :action do
    env = forge_with ["system:install"]
    assert_equality env[:generator_name_original], "system"
    assert_equality env[:generator_name], "system"
    assert_equality env[:generator_action_original], "install"
    assert_equality env[:generator_action], "install"
  end
  
  test :forge, false do
    env = forge_with ["x"]
    assert_equality env[:generator_name_original], "x"
    assert_equality env[:generator_name], "x"
    assert_equality env[:generator_action_original], nil
    assert_equality env[:generator_action], "default"
  end
  
  test :forge, false, :action do
    env = forge_with ["x:y"]
    assert_equality env[:generator_name_original], "x"
    assert_equality env[:generator_name], "x"
    assert_equality env[:generator_action_original], "y"
    assert_equality env[:generator_action], "y"
  end
  
  section :find
  
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
