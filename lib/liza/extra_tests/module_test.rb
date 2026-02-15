class Liza::ModuleTest < Liza::ObjectTest
  
  test :subject_class do
    assert_equality subject_class, Module
  end

  test :source_location do
    assert_equality Object.source_location, []

    assert_equality Liza::Command.source_location[1], 1
    assert_equality IrbCommand.source_location[1], 1
  end

  test :source_location_radical do
    assert_equality Object.source_location_radical, nil

    assert Liza::Command.source_location_radical.end_with? "/lib/dev_system/subsystems/command/command"
    assert IrbCommand.source_location_radical.end_with? "/lib/dev_system/commands/irb_command"
  end

end
