class DevSystem::BenchCommand < DevSystem::SimpleCommand

  def before
    super
    log "simple_args     #{ simple_args }"
    log "simple_booleans #{ simple_booleans }"
    log "simple_strings  #{ simple_strings }"
  end

  # liza bench NAME
  def call_default
    log :higher, "menv.count is #{menv.count}"
    DevBox.bench menv
  end

  # liza bench:controllers
  def call_controllers
    log "not implemented yet"
  end

end
