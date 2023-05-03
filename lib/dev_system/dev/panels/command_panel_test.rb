class DevSystem::CommandPanelTest < Liza::PanelTest

  test :subject_class do
    assert_equality subject_class, DevSystem::CommandPanel
  end

  test :settings do
    assert_equality subject_class.log_level, :normal
    assert_equality subject_class.log_color, :green
  end

  test :call do
    begin
      subject.call ["echo", 1, 2, 3]
      assert false
    rescue RuntimeError => e
      assert e.message == "[1, 2, 3]"
    end
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
  end

  test :find do
    klass = subject.find "generate"
    assert_equality DevSystem::GenerateCommand, klass

    klass = subject.find "g"
    assert_equality DevSystem::NotFoundCommand, klass
  end

end
