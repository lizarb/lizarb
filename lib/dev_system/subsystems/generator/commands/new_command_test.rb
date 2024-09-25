class DevSystem::NewCommandTest < DevSystem::SimpleCommandTest

  test :subject_class do
    assert subject_class == DevSystem::NewCommand
  end

  test_methods_defined do
    on_self
    on_instance :call_default, :call_project, :call_script, :call_script_dependent, :call_script_independent
  end
  
end
