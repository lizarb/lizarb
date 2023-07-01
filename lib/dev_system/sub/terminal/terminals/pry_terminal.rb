class DevSystem::PryTerminal < DevSystem::Terminal

  def self.call args
    log "args = #{args.inspect}"

    Pry.start
  end

end
