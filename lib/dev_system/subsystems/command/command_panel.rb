class DevSystem::CommandPanel < Liza::Panel
  
  part :command_shortcut, :panel

  section :default

  def call args
    log :higher, "args = #{args.inspect}"

    menv = forge args
    forge_shortcut menv
    find menv
    find_shortcut menv
    forward menv
  rescue NameError => e
    if e.message =~ /uninitialized constant (.*)System/
      name = $1
      system_not_found(name, e)
    else
      raise
    end
  end

  #

  def forge args
    args = [""] if args.empty?
    command_arg, *args = args
    command_name_original, command_action_original = command_arg.split(":")
    
    menv = { controller: :command, command_arg:, args:, command_name_original:, command_action_original: }
    
    log :high, "command_name_original:command_action_original is     #{command_name_original}:#{command_action_original}"
    menv
  end

  #

  def system_not_found(name, e)
    key = name.snakecase.to_sym
    
    log ""
    log "#{name}System was used in the following line: #{e.backtrace[0]}"
    log ""

    puts
    puts e.respond_to?(:detailed_message) ? e.detailed_message : e.message
    puts

    log ""
    log "To fix this, please add this line to #{App.file}"
    log ""
    log ""
    log "class App"
    log ""
    log "  system :#{key}"
    log ""
    log "end"
    log ""
  end

end
