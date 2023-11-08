class DevSystem::LogCommand < DevSystem::Command

  def self.call args
    log :lower, "args = #{args}"

    log "Not implemented yet"
  end

end
