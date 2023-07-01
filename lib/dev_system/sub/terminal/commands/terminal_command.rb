class DevSystem::TerminalCommand < DevSystem::Command

  def self.call args
    log "args = #{args}" if DevBox[:terminal].get :log_details

    DevBox[:terminal].call args
  end

  def self.input args
    log "args = #{args}" if DevBox[:terminal].get :log_details

    DevBox[:terminal].input.call args
  end

end
