class DevSystem::CommandPanel < Liza::Panel

  def call args
    # 1. LOG

    log "call #{args}"

    # 2. FIND command

    return call_not_found args if args.none?

    command = args[0]

    log({command:})

    command_klass = Liza.const "#{command}_command"

    # 3. CALL

    command_klass.call args[1..-1]
  rescue Liza::ConstNotFound
    call_not_found args
  end

  def call_not_found args
    Liza::NotFoundCommand.call args
  end
end
