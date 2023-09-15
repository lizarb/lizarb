class Liza::UnitTest < Liza::Test
  test :subject_class do
    assert subject_class == Liza::Unit
  end

  #

  def self.test_methods_defined(&block)
    helper = TestMethodsDefinedHelper.new
    helper.instance_eval(&block)

    test :subject_class, :methods_defined do
      a = subject_class.methods_defined
      b = helper.methods
      assert_equality a, b, kaller: helper.methods_caller
    end

    test :subject_class, :instance_methods_defined do
      a = subject_class.instance_methods_defined
      b = helper.instance_methods
      assert_equality a, b, kaller: helper.instance_methods_caller
    end
  end

  class TestMethodsDefinedHelper
    attr_reader :methods, :methods_caller
    attr_reader :instance_methods, :instance_methods_caller

    def initialize
      @methods, @instance_methods = [], []
      @methods_caller, @instance_methods_caller = caller, caller
    end

    def on_self(*args)
      @methods = args
      @methods_caller = caller
    end

    def on_instance(*args)
      @instance_methods = args
      @instance_methods_caller = caller
    end
  end

  #

  test :subject_class, :methods_defined do
    a = \
      subject_class.methods_defined -
      subject_class.methods_for_settings -
      subject_class.methods_for_logging -
      subject_class.methods_for_rendering
    b = [
      :descendants_select,
      :instance_methods_defined, :instance_methods_for_logging, :instance_methods_for_rendering, :instance_methods_for_settings,
      :methods_defined, :methods_for_logging, :methods_for_rendering, :methods_for_settings,
      :part,
      :procedure, :proceed,
      :reload!,
      :subclasses_select, :system, :system?,
      :test_class
    ]
    assert_equality a, b
  end

  test :subject_class, :instance_methods_defined do
    a = \
      subject_class.instance_methods_defined -
      subject_class.instance_methods_for_settings -
      subject_class.instance_methods_for_logging -
      subject_class.instance_methods_for_rendering
    b = [:procedure, :proceed, :reload!, :system]
    assert_equality a, b
  end

  test :subject_class, :methods_for_settings do
    a = subject_class.methods_for_settings
    b = [:add, :fetch, :get, :set, :settings]
    assert_equality a, b
  end

  test :subject_class, :instance_methods_for_settings do
    a = subject_class.instance_methods_for_settings
    b = [:add, :fetch, :get, :set, :settings]
    assert_equality a, b
  end

  test :subject_class, :methods_for_rendering do
    a = subject_class.methods_for_rendering
    b = [:erbs_available, :erbs_defined, :erbs_for, :renderable_formats_for, :renderable_names]
    assert_equality a, b
  end

  test :subject_class, :instance_methods_for_rendering do
    a = subject_class.instance_methods_for_rendering
    b = [:render, :render!, :render_stack]
    assert_equality a, b
  end

  test :subject_class, :methods_for_logging do
    a = subject_class.methods_for_logging
    b = [:log, :log?, :log_array, :log_color, :log_hash, :log_level, :log_level?, :log_levels]
    assert_equality a, b
  end

  test :subject_class, :instance_methods_for_logging do
    a = subject_class.instance_methods_for_logging
    b = [:log, :log?, :log_array, :log_hash, :log_level, :log_level?, :log_levels, :log_render_convert, :log_render_in, :log_render_out]
    assert_equality a, b
  end

  test :settings do
    assert_equality subject_class.get(:log_level), 0
    assert_equality subject_class.get(:log_color), :white
    assert_equality subject_class.log_level, 0
    assert_equality subject_class.log_color, :white

    assert_equality subject_class.settings, {
      log_level: 0,
      log_color: :white,
      log_erb: false,
      log_render: false
    }
  end

  test :settings_inheritance do
    class_a = Class.new(subject_class) do
      set :number, 1

      add :default, 10
      add :default, 20

      set :array, []
      add :array, 10
      add :array, 20

      add :hash, :a, 10
      add :hash, :b, 20
    end

    assert class_a.settings == {
      number: 1,
      default: Set[10, 20],
      array: [10, 20],
      hash: {a: 10, b: 20}
    }

    assert class_a.get(:default) == Set[10, 20]
    assert class_a.get(:array) == [10, 20]
    assert class_a.get(:hash) == {a: 10, b: 20}

    class_b = Class.new(class_a) do
      set :string, "a"

      add :default, 30
      add :default, 40

      add :array, 30
      add :array, 40

      add :hash, :c, 30
      add :hash, :d, 40
    end

    assert class_a.settings == {
      number: 1,
      default: Set[10, 20],
      array: [10, 20],
      hash: {a: 10, b: 20}
    }

    assert class_a.get(:default) == Set[10, 20]
    assert class_a.get(:array) == [10, 20]
    assert class_a.get(:hash) == {a: 10, b: 20}

    assert class_b.settings == {
      string: "a",
      default: Set[10, 20, 30, 40],
      array: [10, 20, 30, 40],
      hash: {a: 10, b: 20, c: 30, d: 40}
    }

    assert class_b.get(:default) == Set[10, 20, 30, 40]
    assert class_b.get(:array) == [10, 20, 30, 40]
    assert class_b.get(:hash) == {a: 10, b: 20, c: 30, d: 40}
  end

end
