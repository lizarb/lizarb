class WorkSystem::PublisherPanel < Liza::Panel

  section :subsystem

  define_error(:not_found) do |args|
    "publisher not found: #{args[0].inspect}"
  end

  def call(other_env)
    log "not implemented"
  #   log "forging"
  #   env = { other_env: }

  #   log "finding"
  #   k = Liza.const "#{other_env[:publisher]}_publisher"
    
  #   log "forwarding"
  #   k.call env
  # rescue Liza::ConstNotFound
  #   raise_error :not_found, string
  end

end
