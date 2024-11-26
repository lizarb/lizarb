class DevSystem::CommandPanel < Liza::Panel
  
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

end
