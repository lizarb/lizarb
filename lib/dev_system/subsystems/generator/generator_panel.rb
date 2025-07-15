class DevSystem::GeneratorPanel < Liza::Panel

  part :command_shortcut, :panel

  section :default

  def call(command_menv)
    menv = forge command_menv
    forge_shortcut menv
    find menv
    find_shortcut menv
    forward menv
  end

  #

  def forge command_menv
    command = command_menv[:command]
    generator_name_original, generator_action_original = command.args.first.to_s.split(":")

    menv = { controller: :generator, command:, generator_name_original:, generator_action_original: }

    log :high, "generator_name_original:generator_action_original is #{generator_name_original}:#{generator_action_original}"
    menv
  end

end
