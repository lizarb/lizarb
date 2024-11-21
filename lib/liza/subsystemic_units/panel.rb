class Liza::Panel < Liza::Unit

  section :subsystem

  set :box, Liza::Box
  set :controller, Liza::Controller

  #

  def self.instance
    x = self
    x = x.ancestors.take_while { _1.last_namespace == x.last_namespace }.last
    x = x.last_namespace.to_s.sub('Panel', '').snakecase.to_sym
    box.configuration[x]
  end

  def self.box
    system.box
  end

  def box
    system.box
  end

  def self.controller
    @controller ||= system.const token
  end

  def controller
    self.class.controller
  end

  def self.division
    controller.division
  end

  def division
    controller.division
  end

  def self.token
    @token ||= last_namespace.gsub(/Panel$/, '').snakecase.to_sym
  end

  def self.subsystem
    controller
  end

  def subsystem
    controller
  end

  # color

  def self.color
    system.color
  end

  #

  attr_reader :key

  def initialize key
    @key = key
    @blocks = []
    @unstarted = true
  end

  #

  def push block
    @unstarted = true
    @blocks.push block
  end

  def started
    return self unless defined? @unstarted
    remove_instance_variable :@unstarted

    @blocks.each { |bl| instance_eval(&bl) }
    @blocks.clear

    self
  end

  section :errors

  def rescue_from(*args, &block)
    case args.count
    when 1

      e_class = args[0]
      e_class = _rescue_from_parse_error(e_class) if Symbol === e_class

      callable = block if block_given?
      callable ||= :"#{args[0]}_#{key}"

    when 2

      e_class = args[0]
      e_class = _rescue_from_parse_error(e_class) if Symbol === e_class

      callable = :"#{args[1]}_#{key}"
      raise ArgumentError, "wrong number of arguments (2 arguments and a block is not allowed)" if block_given?

    else
    
      raise ArgumentError, "wrong number of arguments (given #{args.count}, expected 1..2)"
    
    end

    unless e_class
      msg = "args #{args} parsed to #{e_class} (expected a descendant of Exception)"
      raise ArgumentError, msg
    end

    e_class_is_exception = e_class.ancestors.include? Exception
    unless e_class_is_exception
      msg = "args #{args} parsed to #{e_class} (expected a descendant of Exception)"
      raise ArgumentError, msg
    end

    rescuer = Rescuer.new
    rescuer[:exception_class] = e_class
    rescuer[:callable] = callable

    rescuers.push(rescuer)
  end

  def _rescue_from_parse_error(symbol)
    s = "#{symbol}_error".camelcase
    self.class.const_get(s)
  rescue NameError => e
    msg = "rescue_from parsed to #{self.class}::#{s} which does not exist"
    puts stick :light_red, msg
    raise e, msg, caller
  end

  #

  def rescuers
    @rescuers ||= []
  end

  #

  def rescue_from_panel(exception, env)
    rescuer = _rescue_from_panel_find exception
    raise exception.class, exception.message, caller[1..-1] unless rescuer

    ret = nil

    log :higher, "rescuer = #{rescuer.inspect}"
    env[:rescuer] = rescuer
    rescuer[:env] = env
    ret = rescuer.call
    log :higher, "ret = #{ret.inspect}"
    ret
  end

  def _rescue_from_panel_find(exception)
    rescuer = rescuers.reverse.find { exception.class.ancestors.include? _1[:exception_class] }
    log :higher, "rescuer = #{rescuer.inspect}"
    return nil unless rescuer
    rescuer = rescuer.dup
    rescuer[:exception] = exception
    rescuer
  end

  #

  class Rescuer < Hash
    def call
      if self[:env]
        callable.call self[:env]
      else
        self[:block].call self
      end
    end

    def callable
      @callable ||= (self[:callable].is_a? Symbol) ? Liza.const(self[:callable]) : self[:callable]
    end
  end


end
