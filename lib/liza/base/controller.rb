class Liza::Controller < Liza::Unit

  part :controller_subsystem

  def self.on_connected box_klass, panel
    # REMEMBER: these are top-level controllers
    # REMEMBER: the class and its settings are already loaded at this point
    subsystem! box_klass, panel
    division!
  end

  def self.log_color
    (box || system).log_color
  end

end
