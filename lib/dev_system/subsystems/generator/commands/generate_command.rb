class DevSystem::GenerateCommand < DevSystem::SimpleCommand

  # liza generate
  def call_default
    DevBox.generate env
  end

  # liza generate:remove
  def call_remove
    DevBox.command ["generate", "remove", *args]
  end

  # liza generate:uninstall
  def call_uninstall
    DevBox.command ["generate", "uninstall", *args]
  end

  # liza generate:install
  def call_install
    DevBox.command ["generate", "install", *args]
  end

  # liza generate:move
  def call_move
    DevBox.command ["generate", "move", *args]
  end

  # liza generate:overwrite
  def call_overwrite
    DevBox.command ["generate", "overwrite", *args]
  end

end
