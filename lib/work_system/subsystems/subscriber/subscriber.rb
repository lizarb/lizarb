class WorkSystem::Subscriber < Liza::Controller

  section :subsystem

  def self.call(menv)
    super
    log stick :b, "TODO: Build a great DSL!"
    log "menv"
    log menv
  end

end
