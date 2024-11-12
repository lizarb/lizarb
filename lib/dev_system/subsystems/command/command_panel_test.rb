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

  test :forge do
    assert_equality \
      (subject.forge ["generate"]),
      {
        :command_arg=>"generate",
        :args=>[],
        :command_name_original=>"generate",
        :command_name=>"generate",
        :command_action_original=>nil,
        :command_action=> "default"
      }

    assert_equality \
      (subject.forge ["generate:install"]),
      {
        :command_arg=>"generate:install",
        :args=>[],
        :command_name_original=>"generate",
        :command_name=>"generate",
        :command_action_original=>"install",
        :command_action=> "install"
      }

    assert_equality \
      (subject.forge ["two_words"]),
      {
        :command_arg=>"two_words",
        :args=>[],
        :command_name_original=>"two_words",
        :command_name=>"two_words",
        :command_action_original=>nil,
        :command_action=> "default"
      }

    assert_equality \
      (subject.forge ["word10"]),
      {
        :command_arg=>"word10",
        :args=>[],
        :command_name_original=>"word10",
        :command_name=>"word10",
        :command_action_original=>nil,
        :command_action=> "default"
      }
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

end
