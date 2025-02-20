class DevSystem::GeneratorPanel < Liza::Panel
  
  part :command_shortcut, :panel

  section :default
  
  def call(command_menv)
    menv = forge command_menv
    forge_shortcut menv
    find menv
    find_shortcut menv
    forward menv
    inform menv
    save menv
  end

  #
  
  def forge command_menv
    command = command_menv[:command]
    generator_name_original, generator_action_original = command.args.first.to_s.split(":")

    menv = { controller: :generator, command:, generator_name_original:, generator_action_original: }

    log :high, "generator_name_original:generator_action_original is #{generator_name_original}:#{generator_action_original}"
    menv
  end
  
  #

  def inform menv
    if log_level? :high
      puts
      log "menv.count is #{menv.count}"
    end
    menv[:generator] or return log :higher, "not implemented"
    menv[:generator].inform
  end

  #

  def save menv
    if log_level? :high
      puts
      log "menv.count is #{menv.count}"
    end
    menv[:generator] or return log :higher, "not implemented"
    menv[:generator].save
  end

end
