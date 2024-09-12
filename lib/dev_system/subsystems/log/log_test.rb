class DevSystem::LogTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Log
  end

  test_methods_defined do
    on_self
    on_instance
  end

end
