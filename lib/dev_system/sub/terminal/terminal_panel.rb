class DevSystem::TerminalPanel < Liza::Panel

  def call args
    log "args = #{args.inspect}" if get :log_details

    terminal = if args.any?
      find args[0]
    else
      default || IrbTerminal
    end

    terminal.call Array(args[1..-1])
  end

  #

  def default name = nil
    @default = find name if name
    @default
  end

  #

  def find string
    Liza.const "#{string}_terminal"
  rescue Liza::ConstNotFound
    Liza::NotFoundTerminal
  end

end
