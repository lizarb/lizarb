class DevSystem::EchoCommand < DevSystem::Command

  def self.call args
    log "args = #{args.inspect}"

    raise RuntimeError, args.to_s
  end

end
