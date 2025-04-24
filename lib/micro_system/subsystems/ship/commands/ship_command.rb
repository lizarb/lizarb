class MicroSystem::ShipCommand < DevSystem::SimpleCommand

  # liza ship
  def call_default
    call_compose
  end

  # liza ship:compose
  def call_compose
    log stick :b, system.color, "I just think Ruby is the Best for coding!"
    return if ship.nil?

    log "Docking #{ship} to docker-compose.yml"
    ship.dock log_level: :higher
  end

  # liza ship:up
  def call_up
    log stick :b, system.color, "I just think Ruby is the Best for coding!"
    return if ship.nil?

    filename = "docker-compose.#{ship.token}.yml"
    log "Docking #{ship} to #{filename}"
    ship.up log_level: :higher, filename:
  end

  def ship
    @ship ||= begin
      default_ship_name = Ship.panel.docked_ship_name || "default"
      ship_name = simple_args[0] || default_ship_name
      Liza.const "#{ship_name}_ship"
    end
  rescue Liza::ConstNotFound => e
    log "Ship not found: #{ship_name}"
    AppShell.consts
    ships = Ship.descendants.select { _1.used_services.any? }
    names = ships.map { _1.last_namespace.snakecase[0..-6] }
    log "Available ships: #{names.join(", ")}"
    nil
  end

end
