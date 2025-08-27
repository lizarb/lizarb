class WorkSystem::EventCommand < DevSystem::SimpleCommand

  # liza event
  def call_default
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"
    log stick :b, :white, :red, "not implemented"
  end

end
