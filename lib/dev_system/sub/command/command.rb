class DevSystem::Command < Liza::Controller

  def self.call args
    log "args = #{args}"
    new.call args
  end

  def call args
    log "args = #{args}"
    raise NotImplementedError
  end

end
