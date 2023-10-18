class DevSystem::TerminalPanel < Liza::Panel
  class AlreadySet < Error; end

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

  def input name = nil
    return (@input || InputTerminal) if name.nil?
    raise AlreadySet, "input already set to #{@input.inspect}, but trying to set to #{name.inspect}", caller if @input
    @input = find "#{name}_input"
  end

  def pick_one title, options = ["Yes", "No"]
    if log_level? :highest
      puts
      log "Pick One"
    end
    input.pick_one title, options
  end

  def pick_many title, options
    if log_level? :highest
      puts
      log "Pick Many"
    end
    # input.pick_many title, options
    TtyInputTerminal.multi_select title, options
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
