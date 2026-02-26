class WebSystem::ServerRack < WebSystem::Rack
  division!

  def self.call(menv)
    super
    url = "http://#{App.name}.localhost:#{menv[:port]}/"
    log "Starting... Please visit #{stick :b, :u, cl.system.color, :white, url}"
  end
end
