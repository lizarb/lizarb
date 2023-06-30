class Liza::ModuleTest < Liza::RubyTest
  
  test :subject_class do
    assert subject_class == Module
  end

  test :source_location do
    assert Object.source_location == []

    assert Liza::Command.source_location[1] == 1
    assert TerminalCommand.source_location[1] == 1
  end

  test :source_location_radical do
    assert Object.source_location_radical == nil

    assert Liza::Command.source_location_radical.end_with? "/lib/dev_system/sub/command/command"
    assert TerminalCommand.source_location_radical.end_with? "/lib/dev_system/dev/controllers/command/terminal_command"
  end

end
