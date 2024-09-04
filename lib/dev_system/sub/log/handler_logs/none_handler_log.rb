class DevSystem::NoneHandlerLog < DevSystem::HandlerLog

  def self.call(env)
    super
    # intentionally left blank
  end
  
end
