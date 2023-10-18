class DevSystem::CommandPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, DevSystem::CommandPanel
  end

  test_methods_defined do
    on_self
    on_instance :call, :call_not_found, :find, :parse
  end

  test :settings do
    assert_equality subject_class.log_level, 0
    assert_equality subject_class.get(:log_erb), false
  end

  test :parse do
    struct = subject.parse "generate"
    assert_equality struct.command, "generate"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, nil
    assert_equality struct.method, nil

    struct = subject.parse "generate:install"
    assert_equality struct.command, "generate"
    assert_equality struct.class_method, "install"
    assert_equality struct.instance_method, nil
    assert_equality struct.method, nil

    struct = subject.parse "generate#install"
    assert_equality struct.command, "generate"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, "install"
    assert_equality struct.method, nil

    struct = subject.parse "generate.install"
    assert_equality struct.command, "generate"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, nil
    assert_equality struct.method, "install"

    struct = subject.parse "two_words"
    assert_equality struct.command, "two_words"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, nil
    assert_equality struct.method, nil

    struct = subject.parse "word10"
    assert_equality struct.command, "word10"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, nil
    assert_equality struct.method, nil
  end

  test :find do
    klass = subject.find "generate"
    assert_equality DevSystem::GenerateCommand, klass

    begin
      klass = subject.find "g"
      assert false
    rescue CommandPanel::NotFoundError
      assert true
    end
  end

end
