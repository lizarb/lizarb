class WebSystem::WebCommand < Liza::Command

  def self.call args
    log "args #{args}"
    log "DEPRECATED: please use `lizarb rack` instead"
    RackCommand.call args
  end

end
