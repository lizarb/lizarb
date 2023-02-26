class DevSystem::VersionCommand < DevSystem::Command

  def self.call args
    puts Lizarb::VERSION
  end

end
