class MicroSystem::ShipCommand < DevSystem::SimpleCommand

  # liza ship
  def call_default
    log stick :b, system.color, "I just think Ruby is the Best for coding!"

    call_compose
  end

  # liza ship:compose
  def call_compose
    log stick :b, system.color, "I just think Ruby is the Best for coding!"
  end

end
