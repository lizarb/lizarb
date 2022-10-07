class MacroParentCommand < AppCommand

  def self.class_macro_method_1(arg)
    log :higher, "Called #{self}.#{__method__} with arg #{arg}"
    @@class_macro_1 = arg
  end

  def self.class_macro_method_2(arg)
    log :higher, "Called #{self}.#{__method__} with arg #{arg}"
    @@class_macro_2 = arg
  end

  def self.class_macro_method_3(arg)
    log :higher, "Called #{self}.#{__method__} with arg #{arg}"
    @@class_macro_3 = arg
  end

  def self.class_macro_method_4(arg)
    log :higher, "Called #{self}.#{__method__} with arg #{arg}"
    @@class_macro_4 = arg
  end

  #

  def self.call(args)
    log :higher, "Called #{self}.#{__method__} with args #{args}"

    if @@class_macro_1
      args << :yes_from_class_call
    else
      args << :no_from_class_call
    end

    command = new(args)
    result = command.call(args)

    puts <<-OUTPUT

      self: #{self}
      args: #{args}
      command: #{command}
      result: #{result}

    OUTPUT
  end

  #

  attr_reader :result

  def initialize(args)
    log :higher, "Called #{self}.#{__method__} with args #{args}"
    @init_args = args

    @result = [args]

    if @@class_macro_2
      @result << :yes_from_initialize
    else
      @result << :no_from_initialize
    end
  end

  #

  def call(args)
    raise NotImplementedError, "implement this on MacroChildCommand"
  end

end
