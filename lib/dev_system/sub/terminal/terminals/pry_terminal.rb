class DevSystem::PryTerminal < DevSystem::Terminal

  def self.call args
    require "pry"
    log "args = #{args.inspect}"

    Pry.start
  end

end
