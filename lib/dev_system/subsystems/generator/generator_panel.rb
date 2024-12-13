class DevSystem::GeneratorPanel < Liza::Panel
  
  part :command_shortcut, :panel

  section :default
  
  def call(command_env)
    env = forge command_env
    forge_shortcut env
    find env
    find_shortcut env
    forward env
    inform env
    save env
  end

  #
  
  def forge command_env
    command = command_env[:command]
    generator_name_original, generator_action_original = command.args.first.to_s.split(":")

    env = { controller: :generator, command:, generator_name_original:, generator_action_original: }

    log :high, "generator_name_original:generator_action_original is #{generator_name_original}:#{generator_action_original}"
    env
  end
  
  #

  def inform env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    env[:generator] or return log :higher, "not implemented"
    env[:generator].inform
  end

  #

  def save env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    env[:generator] or return log :higher, "not implemented"
    env[:generator].save
  end

end
