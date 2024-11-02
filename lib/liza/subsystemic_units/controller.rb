class Liza::Controller < Liza::Unit

  section :subsystem

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

  # subsystem

  def self.subsystem
    get :subsystem
  end

  def self.subsystem?
    get(:subsystem) == self
  end

  def self.subsystem! box_klass, token
    # FIRST, subsystem settings
    panel = box_klass[token]
    set :subsystem, self
    set :box, box_klass
    set :panel, panel

    # LAST, panel settings
    panel.settings.each do |k, v|
      next if settings.key? k
      set k, v
    end
  end

  # box and panel

  def self.box
    get :box
  end

  def self.panel
    get :panel
  end

  def box
    self.class.box
  end

  def panel
    self.class.panel
  end

  # division

  def self.division
    get :division
  end

  def self.division?
    get(:division) == self
  end

  def self.division!
    set :division, self

    camel = last_namespace
    singular = camel.snakecase.to_sym
    plural = "#{camel}s".snakecase.to_sym
    fetch(:singular) { singular }
    fetch(:plural) { plural }
  end

  # grammar

  def self.singular
    case
    when subsystem? then get :singular
    when division?  then :"#{token}_#{subsystem.singular}"
    else                 :"#{token}_#{division.singular}"
    end
  end

  def self.plural
    case
    when subsystem? then get :plural
    when division?  then :"#{token}_#{subsystem.plural}"
    else                 :"#{token}_#{division.plural}"
    end
  end
  
  def self.token
    if subsystem?
      nil
    elsif division?
      last_namespace.gsub(/#{subsystem.last_namespace}$/, '').snakecase.to_sym
    else
      last_namespace.gsub(/#{division.last_namespace}$/, '').snakecase.to_sym
    end
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
