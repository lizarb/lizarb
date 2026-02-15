class DevSystem::SimpleCommandTest < DevSystem::BaseCommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::SimpleCommand
  end

  section :filters

  test_sections(
    :filters=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:before, :after]
    },
    :params=>{
      :constants=>[:Params, :Type, :Field],
      :class_methods=>[],
      :instance_methods=>[:params, :params_parse_type_array, :params_parse_type_integer, :params_parse_type_symbol, :params_parse_type_color, :params_parse_type_subsystem, :params_input_type_string, :params_input_type_boolean, :params_input_type_integer, :params_input_type_color, :params_input_type_array, :params_input_type_subsystem]
    },
    :given=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:given_args, :given_strings, :given_booleans, :before_given]
    },
    :defaults=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:ask?, :confirm?, :default_args, :set_default_arg, :default_strings, :set_default_string, :set_default_array, :default_booleans, :set_default_boolean]
    },
    :input=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:input_args, :input_strings, :input_booleans, :set_input_arg, :set_input_string, :set_input_array, :set_input_boolean]
    },
    :simple=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:simple_arg, :simple_boolean, :simple_string, :simple_array, :simple_args, :simple_args_from_2, :simple_booleans, :simple_strings, :_arg_input_call, :_boolean_input_call, :_string_input_call, :simple_remember, :simple_remember_add, :simple_remember_values, :before_simple, :after_simple]
    },
    :simple_derived=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[
        :simple_color, :simple_controller_placement,
        :simple_arg_ask, :simple_arg_ask_snakecase,
        :simple_boolean_yes,
      ]
    },
    :simple_composed=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:set_arg, :set_boolean, :set_string]
    },
  )

  def forge_subject_with *args
    @subject = subject_class.new
    @subject.instance_exec { @menv = DevBox[:command].forge ["simple", *args] }
    @subject.before
  end

  section :given

  before do
    forge_subject_with "k1=v1", "k3=v3", "la", "le", "li", "+a", "+b", "-c", "-d"
  end

  test :given_strings do
    assert_equality subject.given_strings, {:k1=>"v1", :k3=>"v3"}
  end

  test :given_booleans do
    assert_equality subject.given_booleans, {:a=>true, :b=>true, :c=>false, :d=>false}
  end

  test :given_args do
    assert_equality subject.given_args, ["la", "le", "li"]
  end

  section :defaults

  test :ask?, :given do
    assert_equality subject.ask?, nil

    forge_subject_with "+ask"
    assert_equality subject.ask?, true
  end

  test :ask?, :defaults do
    assert_equality subject.ask?, nil

    forge_subject_with
    subject.set_default_boolean :ask, true
    assert_equality subject.ask?, true
  end

  test :default_args do
    assert_equality subject.default_args, []
  end

  test :set_default_arg do
    subject.set_default_arg 1, "new_thing"
    assert_equality subject.default_args[1], "new_thing"
  end

  test :default_strings do
    assert_equality subject.default_strings, {}
  end

  test :set_default_string do
    subject.set_default_string :views, "eof"
    assert_equality subject.default_strings, {views: "eof"}
  end

  test :default_booleans do
    assert_equality subject.default_booleans, {}
  end

  test :set_default_boolean do
    subject.set_default_boolean :ask, true
    assert_equality subject.default_booleans, {ask: true}
  end

  section :input

  test :input_strings do
    assert_equality subject.input_strings.keys, []
    subject.set_input_string :views, &->{ "eof" }
    assert_equality subject.input_strings.keys, [:views]
  end

  test :input_booleans do
    assert_equality subject.input_booleans.keys, []
    subject.set_input_boolean :ask, &->{ true }
    assert_equality subject.input_booleans.keys, [:ask]
  end

  test :input_args do
    assert_equality subject.input_args, []
    subject.set_input_arg 0, &->{ "eof" }
    assert_equality subject.input_args[0].class, Proc
  end

  section :simple

  test :simple_arg do
    todo "test behavior with given, default and input"
  end

  test :simple_boolean do
    todo "test behavior with given, default and input"
  end

  test :simple_string do
    todo "test behavior with given, default and input"
  end

  section :params

  test :params do
    assert_equality subject.params.class, DevSystem::SimpleCommand::Params
    assert_equality subject.params.types.keys, [:boolean, :string, :array, :integer, :symbol, :color, :subsystem]
    assert_equality subject.params.fields.keys, [:ask, :confirm]
  end

  test :params, :basics do
    prepare_command %w(s0 s1 s2 s3 +b1 +b2 -b3 -b4 k1=v1 k2=v2)

    assert_equality subject.params.args, ["s0", "s1", "s2", "s3"]
    assert_equality subject.params.booleans, {b1: true, b2: true, b3: false, b4: false}
    assert_equality subject.params.strings, {k1: "v1", k2: "v2"}
    assert_equality subject.params.types.keys, [:boolean, :string, :array, :integer, :symbol, :color, :subsystem]
    assert_equality subject.params.fields.keys, [:ask, :confirm]

    assert_equality subject.params[0], "s0"
    assert_equality subject.params[:b1], true
    assert_equality subject.params[:k1], "v1"
    assert_equality subject.params.fields.keys, [:ask, :confirm, 0, :b1, :k1]
  end

  test :params, :ask_and_confirm do
    prepare_command %w(+ask -confirm)

    assert_equality subject.params.args, []
    assert_equality subject.params.booleans, {ask: true, confirm: false}
    assert_equality subject.params.strings, {}
    assert_equality subject.params.types.keys, [:boolean, :string, :array, :integer, :symbol, :color, :subsystem]
    assert_equality subject.params.fields.keys, [:ask, :confirm]

    assert_equality subject.params[:ask], true
    assert_equality subject.params[:confirm], false
  end

  test :params, :named do
    prepare_command %w(level=5) do |params|
      assert_equality params[:level], "5"
    end

    prepare_command %w() do |params|
      params.add_field :level, :integer, default: 3
      assert_equality params[:level], 3
    end

    prepare_command %w(level=5) do |params|
      params.add_field :level, :integer
      assert_equality params[:level], 5
    end
  end

  test :params, :boolean do
    prepare_command %w(+want -need) do |params|
      params.add_field :want, :boolean, default: false
      assert_equality params[:want], true

      params.add_field :need, :boolean, default: true
      assert_equality params[:need], false
    end
  end

  test :params, :integer do
    prepare_command %w(level=5) do |params|
      params.add_field :level, :integer
      assert_equality params[:level], 5
    end

    prepare_command %w() do |params|
      params.add_field :level, :integer, default: 3
      assert_equality params[:level], 3
    end
  end

  test :params, :array do
    prepare_command %w(list=a,b,c) do |params|
      params.add_field :list, :array
      assert_equality params[:list], ["a", "b", "c"]
    end
  end

  test :params, :symbol do
    prepare_command %w(kind=Foo) do |params|
      params.add_field :kind, :symbol
      assert_equality params[:kind], :Foo
    end
  end

  test :params, :color do
    prepare_command %w(color=RED) do |params|
      params.add_field :color, :color
      assert_equality params[:color], :red
    end

    prepare_command %w(color=Green) do |params|
      params.add_field :color, :color
      assert_equality params[:color], :green
    end
  end

  test :params, :string do
    prepare_command %w(name=abc) do |params|
      params.add_field :name, :string
      assert_equality params[:name], "abc"
    end
  end

  def prepare_command(args)
    forge_subject_with *args
    yield subject.params if block_given?
  end

end
