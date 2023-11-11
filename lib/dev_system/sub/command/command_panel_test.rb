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
      :forward, :forward_base_command, :forward_command,
      :inform,
      :input,
      :parse,
      :pick_many, :pick_one
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

  test :parse do
    def parse string
      OpenStruct.new subject.parse(string)
    end

    struct = parse "generate"
    assert_equality struct.command_given, "generate"
    assert_equality struct.command_class_method, nil
    assert_equality struct.command_instance_method, nil
    assert_equality struct.command_method, nil

    struct = parse "generate:install"
    assert_equality struct.command_given, "generate"
    assert_equality struct.command_class_method, "install"
    assert_equality struct.command_instance_method, nil
    assert_equality struct.command_method, nil

    struct = parse "generate#install"
    assert_equality struct.command_given, "generate"
    assert_equality struct.command_class_method, nil
    assert_equality struct.command_instance_method, "install"
    assert_equality struct.command_method, nil

    struct = parse "generate.install"
    assert_equality struct.command_given, "generate"
    assert_equality struct.command_class_method, nil
    assert_equality struct.command_instance_method, nil
    assert_equality struct.command_method, "install"

    struct = parse "two_words"
    assert_equality struct.command_given, "two_words"
    assert_equality struct.command_class_method, nil
    assert_equality struct.command_instance_method, nil
    assert_equality struct.command_method, nil

    struct = parse "word10"
    assert_equality struct.command_given, "word10"
    assert_equality struct.command_class_method, nil
    assert_equality struct.command_instance_method, nil
    assert_equality struct.command_method, nil
  end

  test :find do
    klass = subject._find "generate"
    assert_equality DevSystem::GenerateCommand, klass

    begin
      klass = subject._find "g"
      assert false
    rescue CommandPanel::NotFoundError
      assert true
    end
  end

end
