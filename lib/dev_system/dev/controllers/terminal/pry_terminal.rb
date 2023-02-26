class DevSystem::PryTerminal < DevSystem::Terminal

  def self.call args
    log :higher, "Called #{self}.#{__method__} with args #{args}"

    require "pry"
    Pry.start
  end

end
