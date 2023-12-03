class Liza::Controller < Liza::Unit

  part :controller_subsystem

  def self.on_connected
    token = self.last_namespace.snakecase.to_sym
    panel = system.const("#{token}_panel").new name

    subsystem! system.box, panel
    division!
  end

  def self.inherited klass
    super

    klass.on_connected if klass.superclass == Liza::Controller
  end

  # color

  def self.color
    return system.color if subsystem?
    subsystem.color
  end

end
