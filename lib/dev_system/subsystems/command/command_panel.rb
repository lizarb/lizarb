class DevSystem::CommandPanel < Liza::Panel
  
  define_error(:already_set) do |args|
    "input already set to #{@input.inspect}, but trying to set to #{args[0].inspect}"
  end

  part :command_shortcut, :panel

  section :default

  def call args
    log :higher, "args = #{args.inspect}"

    env = forge args
    forge_shortcut env
    find env
    find_shortcut env
    forward env
  rescue Exception => e
    rescue_from_panel(e, env)
  end

  #

  def forge args
    args = [""] if args.empty?
    command_arg, *args = args
    command_name_original, command_action_original = command_arg.split(":")
    
    env = { controller: :command, command_arg:, args:, command_name_original:, command_action_original: }
    
    log :high, "command_name_original:command_action_original is     #{command_name_original}:#{command_action_original}"
    env
  end

  def _find string
    k = Liza.const "#{string}_command"
    log :higher, k
    k
  rescue Liza::ConstNotFound
    raise_error :not_found, string
  end

  #

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
