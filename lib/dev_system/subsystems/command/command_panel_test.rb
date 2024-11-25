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

  test :forge, "empty" do
    env = forge_with []
    assert_equality env[:command_name_original], nil
    assert_equality env[:command_name], ""
    assert_equality env[:command_action_original], nil
  end

  test :forge, true do
    env = forge_with ["generate"]
    assert_equality env[:command_name_original], "generate"
    assert_equality env[:command_name], "generate"
    assert_equality env[:command_action_original], nil
  end

  test :forge, true, :action do
    env = forge_with ["generate:install"]
    assert_equality env[:command_name_original], "generate"
    assert_equality env[:command_name], "generate"
    assert_equality env[:command_action_original], "install"
  end

  test :forge, false do
    env = forge_with ["x"]
    assert_equality env[:command_name_original], "x"
    assert_equality env[:command_name], "x"
    assert_equality env[:command_action_original], nil
  end

  test :forge, false, :action do
    env = forge_with ["x:y"]
    assert_equality env[:command_name_original], "x"
    assert_equality env[:command_name], "x"
    assert_equality env[:command_action_original], "y"
  end

  test :forge_shortcut do
    subject.shortcut :g, :generate
    env = {controller: :command, command_name_original: "g"}
    subject.forge_shortcut env
    assert_equality env[:command_name], "generate"

    env = {controller: :command, command_name_original: "x"}
    subject.forge_shortcut env
    assert_equality env[:command_name], "x"
  end

  test :find do
    env = {controller: :command, command_name: "generate", command_action_original: ""}
    subject.find env
    assert_equality env[:command_class], DevSystem::GenerateCommand

    env = {controller: :command, ommand_name: "x", command_action_original: ""}
    subject.find env
    assert_equality env[:command_class], DevSystem::NotFoundCommand
  end

  test :find_shortcut do
    env = {controller: :command, command_class: GenerateCommand, command_action_original: "i"}
    subject.find_shortcut env
    assert_equality env[:command_action], "install"

    env = {controller: :command, command_class: GenerateCommand, command_action_original: "x"}
    subject.find_shortcut env
    assert_equality env[:command_action], "x"
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
