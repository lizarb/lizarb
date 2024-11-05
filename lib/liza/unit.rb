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
    return unless const_defined? name
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

  def self.part key, klass = nil, system: nil
    section "#{key}_part"
    part_class ||= if system.nil?
                Liza.const "#{key}_part"
              else
                Liza.const("#{system}_system")
                    .const "#{key}_part"
              end
    self.class_exec(&part_class.insertion) if part_class.insertion
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

  #

  set :log_level, App.log_level
  set :division, Liza::Controller
  
end

__END__

# view render.txt.erb
<%= render if render_stack.any? -%>
