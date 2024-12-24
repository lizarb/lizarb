class DevSystem::BootShell < DevSystem::Shell

  def self.core_loader () = Lizarb.loaders[0]

  def self.app_loader () = Lizarb.loaders[1]

end
