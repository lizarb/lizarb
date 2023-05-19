class DevSystem::GenerateCommand < DevSystem::Command

  def call args
    log "args = #{args}"

    DevBox[:generator].call args
  end

end
