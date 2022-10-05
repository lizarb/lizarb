module Liza
  class UnitTest < Test
    test :subject_class do
      assert subject_class == Liza::Unit
    end

    test :settings do
      assert subject_class.get(:log_level) == :normal
      assert subject_class.get(:log_color) == :white
      assert subject_class.log_level == :normal
      assert subject_class.log_color == :white

      assert subject_class.settings == {log_level: :normal, log_color: :white}
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
end
