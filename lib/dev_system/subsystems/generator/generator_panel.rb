class DevSystem::GeneratorPanel < Liza::Panel
  
  define_error(:not_found) do |args|
    "generator not found: #{args[0].inspect}"
  end

  #
  
  def call(command_env)
    env = {command: command_env[:command]}
    parse env
    find env
    forward env
    inform env
    save env
  rescue Exception => exception
    rescue_from_panel(exception, env)
  end

  #

  def parse env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    command = env[:command]

    raise_error :not_found, "" if command.args.empty?

    generator_name, generator_action = command.args.first.split(":").map(&:to_sym)

    env[:generator_name_original] = generator_name
    env[:generator_name] = short(generator_name).to_sym
    env[:generator_action_original] = generator_action
    env[:generator_action] = generator_action || :default
    log :lower, "generator:action is #{env[:generator_name]}:#{env[:generator_action]}"
  end

  #

  def find env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
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
