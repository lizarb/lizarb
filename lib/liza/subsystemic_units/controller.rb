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
    return :white if self == Liza::Controller
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

  def self.subsystem_token
    get :subsystem_token
  end

  def self.subsystem
    get :subsystem
  end

  def self.subsystem?
    get(:subsystem) == self
  end

  def self.subsystem! box_klass, token
    # FIRST, subsystem settings
    panel = box_klass[token]
    set :subsystem_token, token
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

  section :divisionable

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

  section :grammarable

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

  def self.call(env)
    log :higher, "env.count is #{env.count}" unless self <= DevSystem::Log

    requirements.each do
      log :normal, "require '#{_1}'" unless self <= DevSystem::Log
      Kernel.require _1
    end.clear

    true
  end

  section :requirable

  # This gem will be lazily required
  def self.require(gem_name)
    log :higher, "lazy require '#{gem_name}'" unless self <= DevSystem::Log
    requirements << gem_name
  end

  def self.requirements()= @requirements ||= fetch(:requirements) { [] }

  section :attributable

  def self.attr_reader(*names)
    names.each do |name|
      define_method name do
        log :highest, "@#{name} reads #{instance_variable_get("@#{name}").inspect}" unless name == :menv
        instance_variable_get "@#{name}"
      end
    end
  end

  def self.attr_writer(*names)
    names.each do |name|
      define_method "#{name}=" do |value|
        log :higher, "@#{name} writes #{value.inspect}" unless name == :menv
        instance_variable_set "@#{name}", value
      end
    end
  end

  def self.attr_accessor(*names)
    attr_reader *names
    attr_writer *names
  end

  def attrs
    instance_variables.map do |ivar|
      [ivar, instance_variable_get(ivar)]
    end.to_h
  end

  section :environmentable

  def self.menv_reader(*names)
    names.each do |name|
      define_method name do
        log :highest, "env[:#{name}] reads #{env[name].inspect}", method_name: 'menv_reader'
        raise "env is nil!" unless env
        env[name]
      end
    end
  end
  
  def self.menv_writer(*names)
    names.each do |name|
      define_method "#{name}=" do |value|
        log :higher, "env[:#{name}] writes #{value.inspect}", method_name: 'menv_writer'
        raise "env is nil!" unless env
        env[name] = value
      end
    end
  end
  
  def self.menv_accessor(*names)
    menv_reader *names
    menv_writer *names
  end
  
  attr_accessor :menv
  
  section :default

end
