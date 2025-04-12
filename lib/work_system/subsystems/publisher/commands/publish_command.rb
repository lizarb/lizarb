class WorkSystem::PublishCommand < DevSystem::SimpleCommand

  # liza publish
  def call_default
    call_start
  end

  # liza publish:start
  def call_start
    log stick :b, system.color, "not implemented yet"
  end

end
