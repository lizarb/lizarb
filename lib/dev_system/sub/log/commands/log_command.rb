class DevSystem::LogCommand < DevSystem::Command

  def self.call args
    log :lower, "args = #{args}"

    DevBox[:log].handlers.each do |key, log_class|
      log "handler #{key} maps to #{log_class}"
    end
  end

end
