class WebSystem::ZeitwerkMiddleRack < WebSystem::MiddleRack

  def call(menv)
    puts
    log "reloading"
    Lizarb.reload
    @app.call(menv)
  end

end
