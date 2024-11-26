class NetSystem::FilebasePanel < Liza::Panel

  section :subsystem

  # define_error(:not_found) do |args|
  #   "filebase not found: #{args[0].inspect}"
  # end

  def call(other_env)
    log "not implemented"
  #   log "forging"
  #   env = { other_env: }

  #   log "finding"
  #   k = Liza.const "#{other_env[:filebase]}_filebase"
    
  #   log "forwarding"
  #   k.call env
  # rescue Liza::ConstNotFound
  #   raise_error :not_found, string
  end

end
