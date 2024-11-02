class Liza::Controller < Liza::Unit

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

  section :callable

  # This gem will be lazily required
  def self.require(gem_name)
    @requirements ||= []
    @requirements << gem_name
  end

  def self.call(env)
    log :higher, "env.count is #{env.count}" unless self <= DevSystem::Log

    if defined? @requirements
      @requirements.each do
        log "require '#{_1}'" unless self <= DevSystem::Log
        Kernel.require _1
      end
      remove_instance_variable :@requirements
    end
  end

end
