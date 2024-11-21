class DevSystem::GeneratorPanel < Liza::Panel
  
  define_error(:not_found) do |args|
    "generator not found: #{args[0].inspect}"
  end

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
  rescue Exception => exception
    rescue_from_panel(exception, env)
  end

  #
  
  def forge command_env
    command = command_env[:command]
    env = {controller: :generator, command: command}

    raise_error :not_found, "" if command.args.empty?

    generator_name, generator_action = command.args.first.to_s.split(":")

    env[:generator_name_original] = generator_name
    env[:generator_name] = shortcut(generator_name)
    env[:generator_action_original] = generator_action
    log "generator:action is #{env[:generator_name]}:#{env[:generator_action_original]}"
    env
  end
  
  #

  def find env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    raise_error :not_found, "" if env[:generator_name].empty?
    begin
      k = Liza.const "#{env[:generator_name]}_generator"
      log :higher, k
      env[:generator_class] = k
    rescue Liza::ConstNotFound
      raise_error :not_found, env[:generator_name]
    end
  end

  #

  def forward env
    log :higher, "forwarding"
    env[:generator_class].call env
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
