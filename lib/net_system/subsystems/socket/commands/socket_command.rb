class NetSystem::SocketCommand < DevSystem::SimpleCommand

  section :actions

  # liza socket
  def call_default
    log stick :b, cl.system.color, "I just think Ruby is the Best for coding!"

    log "Not implemented yet"
  end

end
