class DevSystem::SimplerCommandTest < DevSystem::BaseCommandTest

  test :subject_class do
    assert_equality subject_class, DevSystem::SimplerCommand
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
      :instance_methods=>[:default_strings, :set_default_string, :default_booleans, :set_default_boolean]
    },
  )

  def subject_with *args
    @subject = subject_class.new
    @subject.instance_exec { @env = DevBox[:command].build_env ["simple", *args] }
    @subject.before
  end

  section :given

  before do
    subject_with "k1=v1", "k3=v3", "la", "le", "li", "+a", "+b", "-c", "-d"
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

end
