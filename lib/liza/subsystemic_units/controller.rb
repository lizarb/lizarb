class Liza::Controller < Liza::Unit

  section :subsystem

  def self.inherited klass
    super

    if klass.superclass == Liza::Controller
      klass.class_exec do
        token = self.last_namespace.snakecase.to_sym
        subsystem! system.box, token
        division!
      end
    end
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
    else
      last_namespace.gsub(/#{subsystem.last_namespace}$/, '').snakecase.to_sym
    end
  end

  section :callable

  def self.call(menv)
    log :higher, "menv.count is #{menv.count}" unless self <= DevSystem::Log

    requirements.each do
      log :normal, "require '#{_1}'" unless self <= DevSystem::Log
      Kernel.require _1
    end.clear

    true
  end

  def call(menv)
    @menv = menv
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
    attr_reader(*names)
    attr_writer(*names)
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
        log :highest, "menv[:#{name}] reads #{menv[name].inspect}", method_name: 'menv_reader'
        raise "menv is nil!" unless menv
        menv[name]
      end
    end
  end
  
  def self.menv_writer(*names)
    names.each do |name|
      define_method "#{name}=" do |value|
        log :higher, "menv[:#{name}] writes #{value.inspect}", method_name: 'menv_writer'
        raise "menv is nil!" unless menv
        menv[name] = value
      end
    end
  end
  
  def self.menv_accessor(*names)
    menv_reader(*names)
    menv_writer(*names)
  end

  attr_accessor :menv

  def self.env
    @env ||= Env.new "#{system.token}_#{division.singular}"
  end

  def env
    cl.env
  end

  class Env
    def initialize(prefix)
      @prefix = prefix
    end

    def method_missing(name, *args, &block)
      get(name)
    end

    def get?(name)
      get "#{name}?"
    end

    def get(name)
      name = "#{ @prefix }_#{ name }".upcase
      if name[-1] == "?"
        ENV[name[0..-2]]
      else
        ENV.fetch name
      end
    rescue KeyError => e
      puts
      puts e.message
      puts
      puts "Please check your files listed at App.env_vars: #{App.env_vars.inspect}"
      puts
      exit 1
    end
  end

  section :default
end
