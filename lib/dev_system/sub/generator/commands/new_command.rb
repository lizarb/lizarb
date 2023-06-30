class DevSystem::NewCommand < DevSystem::Command

  def call args
    log "args = #{args.inspect}"

    Liza[:GenerateCommand].call ["new", *args]
  end

end
