class Liza::Controller < Liza::Unit

  part :controller_callable
  part :controller_subsystem

  def self.on_connected
    token = self.last_namespace.snakecase.to_sym
    subsystem! system.box, token
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

  def self.sh(s)
    KernelShell.call_system s
  end

  def sh(s)
    KernelShell.call_system s
  end

  def self.`(s)
    KernelShell.call_backticks s
  end

  def `(s)
    KernelShell.call_backticks s
  end

end
