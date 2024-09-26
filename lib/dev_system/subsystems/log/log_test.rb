class DevSystem::LogTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Log
  end

  test_methods_defined do
    on_self
    on_instance
  end

  def call_subject_with(prefix, object, expected)
    env = {object: object, prefix: prefix}
    subject_class.call(env)
    assert_equality expected, env[:object_parsed]
    env
  end

end
