class DevSystem::CommandPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, DevSystem::CommandPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :build_env,
      :call, :call_not_found,
      :find,
      :forward,
      :input,
      :forge,
      :pick_many, :pick_one
  end

  def forge_with args
    env = subject.forge args
    subject.forge_shortcut env
    env
  end

  test :forge, true do
    env = forge_with ["generate"]
    assert_equality env[:command_name_original], "generate"
    assert_equality env[:command_name], "generate"
    assert_equality env[:command_action_original], nil
    assert_equality env[:command_action], "default"
  end

  test :forge, true, :action do
    env = forge_with ["generate:install"]
    assert_equality env[:command_name_original], "generate"
    assert_equality env[:command_name], "generate"
    assert_equality env[:command_action_original], "install"
    assert_equality env[:command_action], "install"
  end

  test :forge, false do
    env = forge_with ["x"]
    assert_equality env[:command_name_original], "x"
    assert_equality env[:command_name], "x"
    assert_equality env[:command_action_original], nil
    assert_equality env[:command_action], "default"
  end

  test :forge, false, :action do
    env = forge_with ["x:y"]
    assert_equality env[:command_name_original], "x"
    assert_equality env[:command_name], "x"
    assert_equality env[:command_action_original], "y"
    assert_equality env[:command_action], "y"
  end

  test :find do
    env = {command_name: "generate"}
    klass = subject.find env
    assert_equality klass, DevSystem::GenerateCommand

    env = {command_name: "x"}
    begin
      klass = subject.find env
      assert false
    rescue CommandPanel::NotFoundError
      assert true
    end
  end

  test :_find do
    klass = subject._find "generate"
    assert_equality DevSystem::GenerateCommand, klass

    begin
      klass = subject._find "g"
      assert false
    rescue CommandPanel::NotFoundError
      assert true
    end
  end

  test :forward do
    todo "test this"
  end

  #

  test :shortcut do
    assert_equality subject.shortcut("m"), "m"
    assert_equality subject.shortcut("i"), "i"
    assert_equality subject.shortcut("n"), "n"
    assert_equality subject.shortcut("s"), "s"
    assert_equality subject.shortcut("w"), "w"
    assert_equality subject.shortcut("a"), "a"
    assert_equality subject.shortcut("n"), "n"

    subject.shortcut :m, :matz
    subject.shortcut :i, :is
    subject.shortcut :n, :nice
    subject.shortcut :s, :so
    subject.shortcut :w, :we
    subject.shortcut :a, :are

    assert_equality subject.shortcut("m"), "matz"
    assert_equality subject.shortcut("i"), "is"
    assert_equality subject.shortcut("n"), "nice"
    assert_equality subject.shortcut("s"), "so"
    assert_equality subject.shortcut("w"), "we"
    assert_equality subject.shortcut("a"), "are"
    assert_equality subject.shortcut("n"), "nice"
  end

end
