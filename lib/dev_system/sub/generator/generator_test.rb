class DevSystem::GeneratorTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Generator
  end

  test_methods_defined do
    on_self :get_generator_signatures
    on_instance
  end

end
