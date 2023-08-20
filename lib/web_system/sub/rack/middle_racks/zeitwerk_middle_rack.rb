class WebSystem::ZeitwerkMiddleRack < WebSystem::MiddleRack

  def call(env)
    puts
    Lizarb.reload do
      log "reloading"
      return @app.call(env)
    end
  end

end
