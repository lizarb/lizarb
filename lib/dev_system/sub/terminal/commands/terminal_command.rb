class DevSystem::TerminalCommand < DevSystem::Command

  def self.call args
    log "args = #{args}" if DevBox[:terminal].get :log_details

    DevBox[:terminal].call args
  end

  def self.input args
    log "args = #{args}" if DevBox[:terminal].get :log_details

    DevBox[:terminal].input.call args
  end

  def self.pallet args
    log "args = #{args.inspect}"

    if args[0]
      args[0] = "#{args[0]}_pallet"
      call args
    else
      DevBox[:terminal].pallet.call args
    end
  end

end
