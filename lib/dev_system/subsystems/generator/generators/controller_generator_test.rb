class DevSystem::ControllerGeneratorTest < DevSystem::SimpleGeneratorTest
  
  test :subject_class, :subject do
    assert_equality subject_class, DevSystem::ControllerGenerator
    assert_equality subject.class, DevSystem::ControllerGenerator
  end

  test_erbs_defined(
    "unit.rb.erb"
  )

  test :before_instance_calls, :before_instance_call do
    assert_equality subject_class.before_instance_calls, [
      [:set_default_views, ["none"], nil],
      [:set_default_division, [false], nil]
    ]
    assert_equality subject_class_subject.before_instance_calls, [
      [:set_default_views, ["none"], nil],
      [:set_default_division, [false], nil]
    ]

    subject_class_subject.set_default_super "base"
    subject_class_subject.set_default_division false
    subject_class_subject.set_default_views "eof"
    subject_class_subject.before_instance_call :foo, "bar", "baz"

    assert_equality! subject_class.before_instance_calls, [
      [:set_default_views, ["none"], nil],
      [:set_default_division, [false], nil]
    ]
    assert_equality subject_class_subject.before_instance_calls, [
      [:set_default_views, ["none"], nil],
      [:set_default_division, [false], nil],
      # new values below
      [:set_default_super, ["base"], nil],
      [:set_default_division, [false], nil],
      [:set_default_views, ["eof"], nil],
      [:foo, ["bar", "baz"], nil]
    ]
  end

  def subject_class_subject() = @subject_class_subject ||= Class.new(subject_class)

end
