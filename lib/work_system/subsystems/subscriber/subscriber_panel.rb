class WorkSystem::SubscriberPanel < Liza::Panel

  section :subsystem

  define_error(:not_found) do |args|
    "subscriber not found: #{args[0].inspect}"
  end

  def call(other_menv)
    log "not implemented"
  #   log "forging"
  #   env = { other_menv: }

  #   log "finding"
  #   k = Liza.const "#{other_menv[:subscriber]}_subscriber"
    
  #   log "forwarding"
  #   k.call env
  # rescue Liza::ConstNotFound
  #   raise_error :not_found, string
  end

end
