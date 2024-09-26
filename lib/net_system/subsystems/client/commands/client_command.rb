class NetSystem::ClientCommand < DevSystem::SimpleCommand
  
  # liza client

  def call_default
    log stick :b, system.color, "I just think Ruby is the Best for coding!"

    log "Not implemented yet"
  end

  
end
