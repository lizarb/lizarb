class DevSystem::GeneratorPanelTest < Liza::PanelTest

  test :subject_class do
    assert subject_class == DevSystem::GeneratorPanel
  end

  test_methods_defined do
    on_self
    on_instance \
      :call,
      :call_not_found,
      :convert, :convert!, :convert?, :converter, :converters, :converters_to,
      :find,
      :format, :format!, :format?, :formatter, :formatters,
      :parse
  end

  test :settings do
    assert_equality subject_class.log_level, 0
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

    begin
      klass = subject.find "c"
      assert false
    rescue GeneratorPanel::ParseError
      assert true
    end
  end

end
