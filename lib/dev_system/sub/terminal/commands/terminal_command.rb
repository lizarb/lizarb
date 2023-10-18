class DevSystem::TerminalCommand < DevSystem::Command

  def self.call args
    log :lower, "args = #{args}"

    DevBox[:terminal].call args
  end

  def self.input args
    log :lower, "args = #{args}"

    DevBox[:terminal].input.call args
  end

  def self.pallet args
    log :lower, "args = #{args}"

    if args[0]
      args[0] = "#{args[0]}_pallet"
      call args
    else
      DevBox[:terminal].pallet.call args
    end
  end

end
