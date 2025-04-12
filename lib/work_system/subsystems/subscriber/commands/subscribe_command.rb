class WorkSystem::SubscribeCommand < DevSystem::SimpleCommand

  # liza subscribe
  def call_default
    call_start
  end

  # liza subscribe:start
  def call_start
    log stick :b, system.color, "not implemented yet"
  end

end
