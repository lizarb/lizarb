class DevSystem::LogTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Log
  end

  test_methods_defined do
    on_self
    on_instance
  end

  def call_subject_with(prefix, object, expected)
    menv = {object: object, prefix: prefix}
    subject_class.call(menv)
    assert_equality expected, menv[:object_parsed]
    menv
  end

end
