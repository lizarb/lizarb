class WebSystem::ZeitwerkMiddleRack < WebSystem::MiddleRack

  def call(env)
    puts
    log "reloading"
    Lizarb.reload
    @app.call(env)
  end

end
