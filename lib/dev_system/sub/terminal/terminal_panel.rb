class DevSystem::TerminalPanel < Liza::Panel

  def call args
    log :lower, "args = #{args.inspect}"

    terminal = if args.any?
      find args[0]
    else
      default || IrbTerminal
    end

    terminal.call Array(args[1..-1])
  rescue Exception => e
    rescue_from_panel(e, with: args)
  end

  #

  def default name = nil
    return @default if name.nil?
    raise AlreadySet, "default already set to #{@default.inspect}, but trying to set to #{name.inspect}", caller if @default
    @default = find name
  end

  #

  def pallet name = nil
    return (@pallet || PalletTerminal) if name.nil?
    raise AlreadySet, "pallet already set to #{@pallet.inspect}, but trying to set to #{name.inspect}", caller if @pallet
    @pallet = find "#{name}_pallet"
  end

  #

  def find string
    Liza.const "#{string}_terminal"
  rescue Liza::ConstNotFound
    Liza::NotFoundTerminal
  end

end
