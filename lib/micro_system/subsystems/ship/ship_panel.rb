class MicroSystem::ShipPanel < Liza::Panel

  section :subsystem

  def call(menv={})
    if docked_ship_name
      menv[:log_level] ||= :low
      docked_ship.dock(menv)
      log "Auto-docked #{docked_ship} to #{menv[:filename]}"
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
