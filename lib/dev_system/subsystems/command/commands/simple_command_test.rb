class DevSystem::SimpleCommandTest < DevSystem::BaseCommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::SimpleCommand
  end

  test_methods_defined do
    on_self
    on_instance \
      :after,
      :before,
      :log_simple_remember,
      :simple_arg, :simple_arg_ask, :simple_arg_ask_snakecase, :simple_args, :simple_args_from_2,
      :simple_boolean, :simple_boolean_no, :simple_boolean_yes, :simple_booleans,
      :simple_color,
      :simple_controller_placement,
      :simple_string, :simple_strings
  end

  def subject_with *args
    @subject = subject_class.new
    @subject.instance_exec { @env = DevBox[:command].build_env ["simple", *args] }
    @subject.before
  end

  before do
    subject_with "k1=v1", "k3=v3", "la", "le", "li", "+a", "+b", "-c", "-d"
  end

  test :simple_strings do
    assert_equality subject.simple_strings, {:k1=>"v1", :k3=>"v3"}
  end

  test :simple_string do
    # Test when the key-value pair is present in the args
    assert_equality subject.simple_string(:k1), "v1"
    assert_equality subject.simple_string(:k3), "v3"

    # Test when the key-value pair is not present in the args and a block is given
    assert_equality subject.simple_string(:k2) { "default" }, "default"

    # Test when the key-value pair is not present in the args and a block is given that returns nil
    assert_equality subject.simple_string(:k2) { nil }, nil

    # Test when the key-value pair is not present in the args and a block is not given
    assert_equality subject.simple_string(:k2), nil
  end

  test :simple_booleans do
    assert_equality subject.simple_booleans, {:a=>true, :b=>true, :c=>false, :d=>false}
  end

  test :simple_boolean do
    assert_equality subject.simple_boolean(:a), true
    assert_equality subject.simple_boolean(:b), true
    assert_equality subject.simple_boolean(:c), false
    assert_equality subject.simple_boolean(:d), false
  end

  test :simple_args do
    assert_equality subject.simple_args, ["la", "le", "li"]
  end

  test :simple_arg do
    assert_equality subject.simple_arg(0), "la"
    assert_equality subject.simple_arg(1), "le"
    assert_equality subject.simple_arg(2), "li"
    assert_equality subject.simple_arg(3), nil
  end

end
