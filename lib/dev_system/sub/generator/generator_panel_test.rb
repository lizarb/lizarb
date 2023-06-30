class DevSystem::GeneratorPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::GeneratorPanel
  end

  test :settings do
    assert subject_class.log_level == :normal
    assert subject_class.log_color == :green
  end

  test :parse do
    struct = subject.parse "system"
    assert_equality struct.generator, "system"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, nil
    assert_equality struct.method, nil

    struct = subject.parse "system:install"
    assert_equality struct.generator, "system"
    assert_equality struct.class_method, "install"
    assert_equality struct.instance_method, nil
    assert_equality struct.method, nil

    struct = subject.parse "system#install"
    assert_equality struct.generator, "system"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, "install"
    assert_equality struct.method, nil

    struct = subject.parse "system.install"
    assert_equality struct.generator, "system"
    assert_equality struct.class_method, nil
    assert_equality struct.instance_method, nil
    assert_equality struct.method, "install"
  end

  test :find do
    klass = subject.find "command"
    assert_equality DevSystem::CommandGenerator, klass

    klass = subject.find "c"
    assert_equality DevSystem::NotFoundGenerator, klass
  end

end
