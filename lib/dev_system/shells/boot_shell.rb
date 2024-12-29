class DevSystem::BootShell < DevSystem::Shell

  def self.core_loader () = Lizarb.loaders[0]

  def self.app_loader () = Lizarb.loaders[1]

  def self.classes
    liza_classes + implementation_classes
  end

  def self.liza_classes
    core_loader.__to_unload.keys.map { Object.const_get _1 }
  end

  def self.implementation_classes
    app_loader.__to_unload.keys.map { Object.const_get _1 }
  end

  def self.system_classes
    implementation_classes.reject { _1.namespace == Object }
  end

  def self.object_classes
    implementation_classes.select { _1.namespace == Object }
  end

end
