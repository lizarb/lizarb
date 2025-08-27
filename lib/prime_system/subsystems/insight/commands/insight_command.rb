class PrimeSystem::InsightCommand < DevSystem::SimpleCommand

  # liza insight
  def call_default
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"
    log stick :b, :white, :red, "not implemented"
  end

end
