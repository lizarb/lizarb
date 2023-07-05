class DevSystem::TerminalPanel < Liza::Panel
  class AlreadySet < Error; end

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
    return @default if name.nil?
    raise AlreadySet, "default already set to #{@default.inspect}, but trying to set to #{name.inspect}", caller if @default
    @default = find name
  end

  #

  def input name = nil
    return (@input || InputTerminal) if name.nil?
    raise AlreadySet, "input already set to #{@input.inspect}, but trying to set to #{name.inspect}", caller if @input
    @input = find "#{name}_input"
  end

  def pick_one title, options = ["Yes", "No"]
    input.pick_one title, options
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
