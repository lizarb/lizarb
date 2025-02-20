class DevSystem::BenchPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::BenchPanel
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
    command_menv = {command: , args: }
    command.instance_variable_set :@menv, command_menv
    menv = subject.forge command_menv
    subject.forge_shortcut menv
    menv
  end
  
  test :forge, true do
    menv = forge_with ["objects"]
    assert_equality menv[:bench_name_original], "objects"
    assert_equality menv[:bench_name], "objects"
    assert_equality menv[:bench_action_original], nil
  end
  
  test :forge, true, :action do
    menv = forge_with ["objects:quadratic"]
    assert_equality menv[:bench_name_original], "objects"
    assert_equality menv[:bench_name], "objects"
    assert_equality menv[:bench_action_original], "quadratic"
  end
  
  test :forge, false do
    menv = forge_with ["x"]
    assert_equality menv[:bench_name_original], "x"
    assert_equality menv[:bench_name], "x"
    assert_equality menv[:bench_action_original], nil
  end
  
  test :forge, false, :action do
    menv = forge_with ["x:y"]
    assert_equality menv[:bench_name_original], "x"
    assert_equality menv[:bench_name], "x"
    assert_equality menv[:bench_action_original], "y"
  end

end
