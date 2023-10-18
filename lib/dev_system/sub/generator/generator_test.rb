class DevSystem::GeneratorTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Generator
  end

  test_methods_defined do
    on_self :main_dsl
    on_instance
  end

  test :settings do
    assert_equality subject_class.log_level, 0
  end

end
