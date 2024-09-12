class DevSystem::CommandTest < Liza::ControllerTest

  test :subject_class do
    assert subject_class == DevSystem::Command
  end

  test_methods_defined do
    on_self :get_command_signatures
    on_instance
  end

end
