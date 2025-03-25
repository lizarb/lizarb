class WorkSystem::ObserverCommand < DevSystem::SimpleCommand

  # liza observer
  def call_default
    log stick :b, system.color, "I just think Ruby is the Best for coding!"
    log stick :b, :white, :red, "not implemented"
  end

end
