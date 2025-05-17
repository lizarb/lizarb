class DevSystem::NoneHandlerLog < DevSystem::HandlerLog

  def self.call(menv)
    super
    # intentionally left blank
  end
  
end
