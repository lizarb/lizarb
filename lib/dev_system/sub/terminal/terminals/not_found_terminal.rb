class DevSystem::NotFoundTerminal < DevSystem::Terminal

  def self.call args
    log "args = #{args.inspect}"
    
    raise "Not found"
  end

end
