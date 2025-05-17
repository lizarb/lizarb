class WebSystem::MiddleRack < WebSystem::Rack

  #

  division!

  #
  
  def initialize app
    @app = app
  end

  def call(menv)
    log :high, "menv.keys.count = #{menv.keys.count}"
    @app.call(menv)
  end

end
