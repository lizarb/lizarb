class ExampleCommand < AppCommand

  def self.call(args)
    log :higher, "Called #{self}.#{__method__} with args #{args}"

    class_helper_method_1(args)
    class_helper_method_2(args)
    class_helper_method_3(args)

    command = new(args)
    command.helper_method_1(args)
    command.helper_method_2(args)
    command.helper_method_3(args)
  end

  #

  def self.class_helper_method_1(args)
    log :higher, "Called #{self}.#{__method__} with args #{args}"
    1
  end

  def self.class_helper_method_2(args)
    log :higher, "Called #{self}.#{__method__} with args #{args}"
    2
  end

  def self.class_helper_method_3(args)
    log :higher, "Called #{self}.#{__method__} with args #{args}"
    3
  end

  #

  def initialize(args)
    log :higher, "Called #{self}.#{__method__} with args #{args}"
    @init_args = args
  end

  #

  def helper_method_1(args)
    log :higher, "Called #{self}.#{__method__} (which has @init_args #{@init_args}) with args #{args}"
    @init_args[0]
  end

  def helper_method_2(args)
    log :higher, "Called #{self}.#{__method__} (which has @init_args #{@init_args}) with args #{args}"
    @init_args[1]
  end

  def helper_method_3(args)
    log :higher, "Called #{self}.#{__method__} (which has @init_args #{@init_args}) with args #{args}"
    @init_args[2]
  end

end
