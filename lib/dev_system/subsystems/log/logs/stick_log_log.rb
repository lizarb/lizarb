class DevSystem::StickLogLog < DevSystem::Log
  def self.call(menv)
    menv[:object_parsed] = menv[:object].to_s
    true
  end
end
