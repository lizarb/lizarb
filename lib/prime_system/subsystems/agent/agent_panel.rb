class PrimeSystem::AgentPanel < Liza::Panel

  section :subsystem

  define_error(:not_found) do |args|
    "agent not found: #{args[0].inspect}"
  end

  def call(other_menv)
    log "not implemented"
  #   log "forging"
  #   menv = { other_menv: }

  #   log "finding"
  #   k = Liza.const "#{other_menv[:agent]}_agent"
    
  #   log "forwarding"
  #   k.call menv
  # rescue Liza::ConstNotFound
  #   raise_error :not_found, string
  end

end
