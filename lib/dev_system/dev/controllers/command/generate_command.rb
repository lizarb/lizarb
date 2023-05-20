class DevSystem::GenerateCommand < DevSystem::Command

  def call args
    log "args = #{args}" if DevBox[:generator].get :log_details

    DevBox[:generator].call args
  end

end
