class NetSystem::Filebase < Liza::Controller

  section :subsystem

  def self.call(env)
    super
    log stick :b, "TODO: Build a great DSL!"
    log "env"
    log env
  end

end
