class DevSystem::BaseGenerator < DevSystem::Generator

  section :panel

  def self.call(menv)
    super
    
    generator = new
    menv[:generator] = generator
    menv[:command].menv[:generator] = generator
    generator.call menv
  end

  #

  def call(menv)
    super
    
    before
    method_name = "call_#{action_name}"
    if respond_to? method_name
      public_send method_name
      after
      return true
    end

    log "method not found: #{method_name.inspect}"

    raise NoMethodError, "method not found: #{method_name.inspect}", caller 
  end

  def inform
    log "not implemented"
  end

  def save
    log "not implemented"
  end

  section :filters

  def before
    before_default
    before_input
  end

  def after
    #
  end

  section :helper_methods

  def action_name()= menv[:generator_action]

  section :command

  def args
    command.args
  end

  def command
    menv[:command]
  end

  #

  def self.get_generator_signatures
    signatures = []
    ancestors_until(BaseGenerator).each do |c|
      signatures +=
        c.instance_methods_defined.select do |name|
          name.start_with? "call_"
        end.map do |name|
          {
            name: ( name.to_s.sub("call_", "").sub("default", "") ),
            description: "# no description",
          }
        end
    end
    signatures.uniq { _1[:name] }
  end

  def before_default
    default_args.each_with_index { |arg, i| set_default_arg i, arg }
    default_booleans.each { |name, value| set_default_boolean name, value }
    default_strings.each { |key, value| set_default_string key, value }
  end

  def self.default_args() = fetch(:default_args) { [] }

  def self.default_booleans() = fetch(:default_booleans) { {} }

  def self.default_strings() = fetch(:default_strings) { {} }

  def self.set_default_arg(index, value) = default_args[index] = value

  def self.set_default_boolean(name, value) = default_booleans[name] = value

  def self.set_default_string(key, value) = default_strings[key] = value

  def default_args() = fetch(:default_args) { [] }

  def default_booleans() = fetch(:default_booleans) { {} }

  def default_strings() = fetch(:default_strings) { {} }

  def set_default_arg(index, value) = command.set_default_arg index, value

  def set_default_boolean(name, value) = command.set_default_boolean name, value

  def set_default_string(key, value) = command.set_default_string key, value

  def before_input
    input_args.each { |index, block| set_input_arg index, &block }
    input_booleans.each { |name, block| set_input_boolean name, &block }
    input_strings.each { |key, block| set_input_string key, &block }
  end

  def self.input_args() = fetch(:input_args) { {} }

  def self.input_booleans() = fetch(:input_booleans) { {} }

  def self.input_strings() = fetch(:input_strings) { {} }

  def self.set_input_arg(index, &block) = input_args[index] = block

  def self.set_input_boolean(name, &block) = input_booleans[name] = block

  def self.set_input_string(key, &block) = input_strings[key] = block

  def input_args() = fetch(:input_args) { {} }

  def input_booleans() = fetch(:input_booleans) { {} }

  def input_strings() = fetch(:input_strings) { {} }

  def set_input_arg(index, &block) = command.set_input_arg index, &block

  def set_input_boolean(name, &block) = command.set_input_boolean name, &block

  def set_input_string(key, &block) = command.set_input_string key, &block

end
