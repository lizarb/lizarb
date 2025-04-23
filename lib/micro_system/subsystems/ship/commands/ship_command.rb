class MicroSystem::ShipCommand < DevSystem::SimpleCommand

  # liza ship
  def call_default
    call_compose
  end

  # liza ship:compose
  def call_compose
    log stick :b, system.color, "I just think Ruby is the Best for coding!"

    default_ship_name = Ship.panel.docked_ship_name || "default"
    ship_name = simple_args[0] || default_ship_name
    ship = Liza.const "#{ship_name}_ship"
    ship.dock log_level: :higher
  rescue Liza::ConstNotFound => e
    log "Ship not found: #{ship_name}"
    AppShell.consts
    ships = Ship.descendants.select { _1.used_services.any? }
    names = ships.map { _1.last_namespace.snakecase[0..-6] }
    log "Available ships: #{names.join(", ")}"
  end

end
