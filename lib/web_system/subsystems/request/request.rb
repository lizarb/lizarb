class WebSystem::Request < Liza::Controller

  def self.path_for(action)
    panel.path_for self, action
  end

end
