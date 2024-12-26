class DevSystem::ControllerShellTest < DevSystem::ShellTest

  test :subject_class do
    assert_equality subject_class, DevSystem::ControllerShell
  end

  test :places_for do
    places = subject_class.places_for(Shell, directory_name: "shells")
    assert_equality places.class, Hash

    assert_equality places["app"],           "app/dev/shells"
    assert_equality places["dev"],           "lib/dev_system/shells"
    assert_equality places["dev/bench"],     "lib/dev_system/subsystems/bench/shells"
    assert_equality places["dev/command"],   "lib/dev_system/subsystems/command/shells"
    assert_equality places["dev/generator"], "lib/dev_system/subsystems/generator/shells"
    assert_equality places["dev/log"],       "lib/dev_system/subsystems/log/shells"
    assert_equality places["dev/shell"],     "lib/dev_system/subsystems/shell/shells"
    assert_equality places["happy"],         "lib/happy_system/shells"

    places = subject_class.places_for(Shell, directory_name: "gem_shells")
    assert_equality places.class, Hash

    assert_equality places["app"],           "app/dev/gem_shells"
    assert_equality places["dev"],           "lib/dev_system/gem_shells"
    assert_equality places["dev/bench"],     "lib/dev_system/subsystems/bench/gem_shells"
    assert_equality places["dev/command"],   "lib/dev_system/subsystems/command/gem_shells"
    assert_equality places["dev/generator"], "lib/dev_system/subsystems/generator/gem_shells"
    assert_equality places["dev/log"],       "lib/dev_system/subsystems/log/gem_shells"
    assert_equality places["dev/shell"],     "lib/dev_system/subsystems/shell/gem_shells"
    assert_equality places["happy"],         "lib/happy_system/gem_shells"
  end

end
