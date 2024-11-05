class Liza::UnitTest < Liza::Test
  test :subject_class do
    assert subject_class == Liza::Unit
  end

  #

  def self.test_methods_defined(&block)
    test :subject_class, :methods_defined do
      todo "replace me with test_sections"
    end
  end

  #
  
  def self.test_sections(hash)
    test :sections do
      assert_equality! subject_class.sections.keys, hash.keys

      # each section should match the hash
      group do
        hash.each do |section_name, section|
          assert_equality section, subject_class.sections[section_name]
        end
      end

      hash_class_methods = hash.values.map { _1[:class_methods] }.flatten
      hash_instance_methods = hash.values.map { _1[:instance_methods] }.flatten

      actual_class_methods = subject_class.sections.values.map { _1[:class_methods] }.flatten
      actual_instance_methods = subject_class.sections.values.map { _1[:instance_methods] }.flatten

      # each section should have unique methods
      group do
        assert_equality actual_class_methods, hash_class_methods
        assert_equality actual_instance_methods, hash_instance_methods
      end

      # methods in all sections should be unique
      group do
        assert_equality actual_class_methods.sort, actual_class_methods.sort.uniq
        assert_equality actual_instance_methods.sort, actual_instance_methods.sort.uniq
      end
    end
  end

  test_sections(
    :default=>{
      :constants=>[:Error],
      :class_methods=>[:singleton_method_added, :section, :sections, :method_added, :const_added, :methods_defined, :class_methods_defined, :instance_methods_defined, :constants_defined, :part, :const_missing, :reload!],
      :instance_methods=>[:reload!]
    },
    unit_setting_part: {
      :constants=>[],
      :class_methods=>[:settings, :get, :set, :add, :fetch],
      :instance_methods=>[:settings, :get, :set, :add, :fetch]
    },
    unit_associating_part: {
      :constants=>[],
      :class_methods=>[:namespace, :subclasses_select, :descendants_select, :subunits, :system?, :test_class, :division, :system],
      :instance_methods=>[:system]
    },
    unit_erroring_part: {
      :constants=>[],
      :class_methods=>[:errors, :define_error, :raise_error],
      :instance_methods=>[:raise_error]
    },
    unit_logging_part: {
      :constants=>[],
      :class_methods=>[:log_levels, :log, :stick, :sticks, :log_level, :log_hash, :log_array, :log?, :log_level?],
      :instance_methods=>[:log_levels, :log, :stick, :sticks, :log_level, :log_hash, :log_array, :log?, :log_level?]
    },
    unit_rendering_part: {
      :constants=>[:RendererNotFoundError, :RenderStackIsEmptyError, :RenderStackIsFullError],
      :class_methods=>[:erbs_defined, :erbs_available, :renderable_names, :renderable_formats_for, :erbs_for, :_erbs_for],
      :instance_methods=>[:render!, :render, :render_stack, :log_render_in, :log_render_out, :log_render_convert, :log_render_format]
    }
  )

  #

  test :settings do
    assert_equality subject_class.get(:log_level), 4
    assert_equality subject_class.log_level, 4

    assert_equality subject_class.settings, {
      log_level: 4,
      division: Liza::Controller,
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
