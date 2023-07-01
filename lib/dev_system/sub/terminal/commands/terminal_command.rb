class DevSystem::TerminalCommand < DevSystem::Command

  def call args
    log "args = #{args}" if DevBox[:terminal].get :log_details

    DevBox[:terminal].call args
  end

end
