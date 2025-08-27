class PrimeSystem::EpicCommand < DevSystem::SimpleCommand

  section :actions

  # liza epic
  def call_default
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    log "Not implemented yet"
  end

end
