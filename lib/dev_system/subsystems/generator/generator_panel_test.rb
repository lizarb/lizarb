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
      :forge
  end
  
  section :forge
  
  def forge_with(args)
    command = SimpleCommand.new
    command_env = {command: , args: }
    command.instance_variable_set :@menv, command_env
    env = subject.forge command_env
    subject.forge_shortcut env
    env
  end
  
  test :forge, true do
    env = forge_with ["system"]
    assert_equality env[:generator_name_original], "system"
    assert_equality env[:generator_name], "system"
    assert_equality env[:generator_action_original], nil
  end
  
  test :forge, true, :action do
    env = forge_with ["system:install"]
    assert_equality env[:generator_name_original], "system"
    assert_equality env[:generator_name], "system"
    assert_equality env[:generator_action_original], "install"
  end
  
  test :forge, false do
    env = forge_with ["x"]
    assert_equality env[:generator_name_original], "x"
    assert_equality env[:generator_name], "x"
    assert_equality env[:generator_action_original], nil
  end
  
  test :forge, false, :action do
    env = forge_with ["x:y"]
    assert_equality env[:generator_name_original], "x"
    assert_equality env[:generator_name], "x"
    assert_equality env[:generator_action_original], "y"
  end

  test :forge_shortcut do
    subject.shortcut :s, :system
    env = {controller: :generator, generator_name_original: "s"}
    subject.forge_shortcut env
    assert_equality env[:generator_name], "system"

    env = {controller: :generator, generator_name_original: "zz"}
    subject.forge_shortcut env
    assert_equality env[:generator_name], "zz"
  end
  
  section :find

  test :find do
    env = {controller: :generator, generator_name: :command}
    subject.find env
    assert_equality env[:generator_class], CommandGenerator

    env = {controller: :generator, generator_name: :z}
    subject.find env
    assert_equality env[:generator_class], NotFoundGenerator
  end

  test :find_shortcut do
    env = {controller: :generator, generator_class: CommandGenerator, generator_action_original: "x"}
    subject.find_shortcut env
    assert_equality env[:generator_action], "x"
  end

end
