class DevSystem::StickLogLog < DevSystem::Log
  def self.call(env)
    env[:object_parsed] = env[:object].to_s
    true
  end
end
