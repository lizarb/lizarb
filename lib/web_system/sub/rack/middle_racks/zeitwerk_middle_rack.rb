class WebSystem::ZeitwerkMiddleRack < WebSystem::MiddleRack

  def call(env)
    App.reload do
      log "reloading"
      return @app.call(env)
    end
  end

end
