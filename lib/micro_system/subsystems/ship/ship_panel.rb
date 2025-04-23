class MicroSystem::ShipPanel < Liza::Panel

  section :subsystem

  def call(menv={})
    if docked_ship_name
      log "Auto-docking #{docked_ship} to docker-compose.yml"
      docked_ship.dock
    end
  end

  def auto_dock(name)
    @docked_ship_name = name
  end

  def docked_ship
    Liza.const "#{docked_ship_name}_ship"
  end

  def docked_ship_name
    @docked_ship_name
  end

end
