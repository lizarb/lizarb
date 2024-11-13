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
    :given=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:given_args, :given_strings, :given_booleans, :before_given]
    },
    :defaults=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:ask?, :default_args, :set_default_arg, :default_strings, :set_default_string, :default_booleans, :set_default_boolean]
    },
    :input=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:input_args, :input_strings, :input_booleans, :set_input_arg, :set_input_string, :set_input_boolean]
    },
    :simple=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[:simple_arg, :simple_boolean, :simple_string, :simple_args, :simple_args_from_2, :simple_booleans, :simple_strings, :_arg_input_call, :_boolean_input_call, :_string_input_call, :simple_remember, :simple_remember_add, :simple_remember_values, :before_simple, :after_simple]
    },
    :simple_derived=>{
      :constants=>[],
      :class_methods=>[],
      :instance_methods=>[
        :simple_color, :simple_controller_placement,
        :simple_arg_ask, :simple_arg_ask_snakecase,
        :simple_boolean_yes, :simple_boolean_no,
      ]
    },
  )

  def forge_subject_with *args
    @subject = subject_class.new
    @subject.instance_exec { @env = DevBox[:command].forge ["simple", *args] }
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

end
