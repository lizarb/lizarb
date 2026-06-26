class MicroSystem::ShipCommand < DevSystem::SimpleCommand

  # liza ship
  def call_default
    call_up
  end

  # liza ship:up
  def call_up
    return if ship.nil?

    log stick :b, cl.system.color, "Docking #{ship}"
    ship.up log_level: :higher
  end

  # liza ship:start
  def call_start
    return if ship.nil?

    log stick :b, cl.system.color, "Docking #{ship}"
    ship.start log_level: :higher
  end

  # liza ship:stop
  def call_stop
    return if ship.nil?

    log stick :b, cl.system.color, "Docking #{ship}"
    ship.stop log_level: :higher
  end

  # liza ship:restart
  def call_restart
    return if ship.nil?

    log stick :b, cl.system.color, "Docking #{ship}"
    ship.restart log_level: :higher
  end

  # liza ship:compose
  def call_compose
    return if ship.nil?

    log stick :b, cl.system.color, "Docking #{ship}"
    ship.dock log_level: :higher
  end

  # liza ship:terminal 0       1         2
  # liza ship:terminal SHIP    SERVICE   TERMINAL
  # liza ship:terminal default long_name create
  def call_terminal
    return if ship.nil?

    params.expect 1, :symbol
    service = params[1]
    params.expect 2, :symbol
    terminal_key = params[2]
    terminal_args = params[3..]

    logc "Docking #{ship} before a terminal call to #{service}/#{terminal_key} with args #{terminal_args.inspect}"
    ship.terminal service, terminal_key, terminal_args, log_level: :higher
  end

  # liza ship:create_network
  def call_create_network
    return if ship.nil?

    log stick :b, cl.system.color, "Creating network for #{ship}"
    ship.create_network log_level: :higher
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
