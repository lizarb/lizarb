class Liza::ModuleTest < Liza::ObjectTest
  
  test :subject_class do
    assert subject_class == Module
  end

  test :source_location do
    assert Object.source_location == []

    assert Liza::Command.source_location[1] == 1
    assert IrbCommand.source_location[1] == 2
  end

  test :source_location_radical do
    assert Object.source_location_radical == nil

    assert Liza::Command.source_location_radical.end_with? "/lib/dev_system/subsystems/command/command"
    assert IrbCommand.source_location_radical.end_with? "/lib/dev_system/subsystems/command/commands/irb_command"
  end

end
