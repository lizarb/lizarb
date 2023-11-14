class DevSystem::AppShell < DevSystem::Shell

  #
  
  def self.writable_systems
    root = App.root.to_s
    App.systems.select { _2.source_location_radical.start_with? root }
  end

end
