class DevSystem::GenerateCommand < DevSystem::SimpleCommand

  shortcut :m, :move
  shortcut :o, :override
  shortcut :r, :remove

  # liza generate
  def call_default
    DevBox.generate menv
  end

  # liza generate:move
  def call_move
    DevBox.command ["generate", "move", *args]
  end

  # liza generate:override
  def call_override
    DevBox.command ["generate", "override", *args]
  end

  # liza generate:remove
  def call_remove
    DevBox.command ["generate", "remove", *args]
  end

end
