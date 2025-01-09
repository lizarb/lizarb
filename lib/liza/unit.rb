class Liza::Unit

  # Define a section
  def self.section(name)
    @current_section = name.to_sym
  end

  # Retrieve the sections
  def self.sections
    @sections ||= Hash.new { |h, k| h[k] = { constants: [], class_methods: [], instance_methods: [] } }
  end

  # Hook into singleton method definition to capture class methods under the current section
  def self.singleton_method_added(method_name)
    sections[@current_section || :default][:class_methods] << method_name
  end

  singleton_method_added :section
  singleton_method_added :sections

  # Hook into method definition to capture instance methods under the current section
  def self.method_added(method_name)
    sections[@current_section || :default][:instance_methods] << method_name
  end

  # Hook into constant definition to capture constants under the current section
  def self.const_added(name)
    super
    # ensures dynamic constants are not captured
    return unless const_defined? name
    # ensures constants defined in the System class are not captured
    return if self < Liza::System
    sections[@current_section || :default][:constants] << name
  end

  # Alias for class_methods_defined
  def self.methods_defined() = class_methods_defined

  # Retrieves all defined class methods.
  # @return [Array<Symbol>] an array of all defined class method names
  def self.class_methods_defined() = sections.values.map { _1[:class_methods] }.flatten

  # Retrieves all defined instance methods.
  # @return [Array<Symbol>] an array of all defined instance method names
  def self.instance_methods_defined() = sections.values.map { _1[:instance_methods] }.flatten

  # Retrieves all defined constants.
  # @return [Array<Symbol>] an array of all defined constant names
  def self.constants_defined() = sections.values.map { _1[:constants] }.flatten

  # ERROR
  
  class Error < Liza::Error; end

  # PART

  # Inserts a part into the unit.
  # @param key [Symbol] the key of the part
  # @param insertion [Symbol] the insertion method
  def self.part(key, insertion = :default)
    part_class = Liza.const "#{key}_part"
    insertion = part_class.insertion(insertion)

    section "#{key}_part"
    class_exec(&insertion)
  end

  # CONST MISSING

  def self.const_missing name
    Liza.const name
  rescue Liza::ConstNotFound
    if Lizarb.ruby_supports_raise_cause?
      raise NameError, "uninitialized constant #{name}", caller[1..], cause: nil
    else
      raise NameError, "uninitialized constant #{name}", caller
    end
  end

  # PARTS

  part :unit_setting

  part :unit_associating

  part :unit_erroring

  part :unit_logging

  part :unit_rendering

  section :default
  
  def self.reload!
    Lizarb.reload
  end

  def reload!
    Lizarb.reload
  end

  ##
  # :call-seq:
  #   Unit.cl -> Class
  #
  # Returns the class itself.
  def self.cl() = self
  
  ##
  # :call-seq:
  #   unit_instance.cl -> Class
  #
  # Returns the class of the current instance.
  def cl() = self.class

  ##
  # :call-seq:
  #   Unit.time_diff(t[, digits]) -> String
  #
  # Returns a time difference string with a fixed decimal precision. 
  #
  # - +t+: A time-like object to compare to the current time.
  # - +digits+: Integer specifying the decimal precision (defaults to 4).
  #
  # Raises ArgumentError if +digits+ is not a positive Integer.
  #
  def self.time_diff(t, digits = 4)
    raise ArgumentError, "digits must be a positive integer" unless digits.is_a?(Integer) && digits.positive?
    f = (Time.now.to_f - t.to_f).floor(digits)
    u, d = f.to_s.split "."
    "#{u}.#{d.ljust digits, "0"}"
  end

  ##
  # :call-seq:
  #   unit_instance.time_diff(t[, digits]) -> String
  #
  # Convenience instance method delegating to +Unit.time_diff+.
  # Returns the time difference string with the specified decimal precision.
  #
  def time_diff(t, digits = 4)= self.class.time_diff t, digits

  set :log_level, App.log_level
  set :division, Liza::Controller
  
end

__END__

# view render.txt.erb
<%= render if render_stack.any? -%>
