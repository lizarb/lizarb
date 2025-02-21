class WebSystem::MiddleRack < WebSystem::Rack

  #

  division!

  #
  
  def initialize app
    @app = app
  end

  def call(env)
    log :high, "env.keys.count = #{env.keys.count}"
    @app.call(env)
  end

end
