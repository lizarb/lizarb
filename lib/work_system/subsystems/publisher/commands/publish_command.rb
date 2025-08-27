class WorkSystem::PublishCommand < DevSystem::SimpleCommand

  # liza publish
  def call_default
    call_start
  end

  # liza publish:start
  def call_start
    log stick :b, cl.system.color, "not implemented yet"
  end

end
