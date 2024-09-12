class DevSystem::ControllerShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::ControllerShell
  end

  test :places_for do
    places = subject_class.places_for(Shell)
    assert_equality places.class, Hash
  end

end
