class DevSystem::CommandPanel < Liza::Panel
  
  define_error(:parse) do |args|
    "could not parse #{args[0].inspect}"
  end

  define_error(:not_found) do |args|
    "command not found: #{args[0].inspect}"
  end

  define_error(:already_set) do |args|
    "input already set to #{@input.inspect}, but trying to set to #{args[0].inspect}"
  end

  def call args
    log :higher, "args = #{args.inspect}"

    return call_not_found args if args.none?

    env = forge args
    find env
    forward env
  # rescue Exception => e
  rescue Error => e
    rescue_from_panel(e, env)
  end

  #

  def forge args
    command_arg, *args = args
    command_name, command_action = command_arg.split(":")
    env = {command_arg: , args:}
    env[:command_name_original] = command_name
    env[:command_name] = shortcut(command_name)
    env[:command_action_original] = command_action
    env[:command_action] = shortcut command_action || "default"
    log "command:action is #{env[:command_name]}:#{env[:command_action]}"
    env
  end

  #

  def find env
    raise "env[:command_name] is empty #{env}" if env[:command_name].empty?
    env[:command_class] = Liza.const "#{env[:command_name]}_command"
  rescue Liza::ConstNotFound
    raise_error :not_found, env[:command_name]
  end

  def _find string
    k = Liza.const "#{string}_command"
    log :higher, k
    k
  rescue Liza::ConstNotFound
    raise_error :not_found, string
  end

  #

  def forward env
    log :higher,  "forwarding"
    env[:command_class].call env
  end

  #

  def call_not_found args
    Liza[:NotFoundCommand].call args
  end

  section :shortcuts

  def shortcuts () = @shortcuts ||= {}
  
  def shortcut(a, b = nil)
    if b
      shortcuts[a.to_s] = b.to_s
    else
      shortcuts[a.to_s] || a.to_s
    end
  end

  section :input

  def input name = nil
    return (@input || InputCommand) if name.nil?
    raise_error :already_set, name
    @input = _find "#{name}_input"
  end

  def pick_one title, options = ["Yes", "No"]
    if log_level? :lowest
      puts
      log "Pick One"
    end
    # input.pick_one title, options
    TtyInputCommand.pick_one title, options
  end

  def pick_many title, options
    if log_level? :lowest
      puts
      log "Pick Many"
    end
    # input.pick_many title, options
    TtyInputCommand.multi_select title, options
  end

end
