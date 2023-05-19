class DevSystem::PryTerminal < DevSystem::Terminal

  def self.call args
    log "args = #{args.inspect}"

    require "pry"
    Pry.start
  end

end
