class DevSystem::EchoCommand < DevSystem::Command

  def self.call args
    log :higher, "Called #{self} with args #{args}"

    raise RuntimeError, args.to_s
  end

end
