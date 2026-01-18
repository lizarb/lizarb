class DevSystem::SimpleCommand < DevSystem::BaseCommand

  section :filters

  def before
    super
    before_given
    before_simple
    @params ||= Params.new(self)
  end

  def after
    super
    after_simple
  end

  section :params

  # Returns the DevSystem::SimpleCommand::Params object associated with this command.
  # @return [DevSystem::SimpleCommand::Params]
  attr_reader :params

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Parses an array from a comma-separated string.
  # @param string [String] The string to parse.
  # @return [Array<String>]
  def params_parse_type_array(string)
    string.to_s.split(",")
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Parses an integer from a string.
  # @param string [String] The string to parse.
  # @return [Integer]
  # @raise [RuntimeError] If the string is not a valid integer.
  def params_parse_type_integer(string)
    int = string.to_i
    raise "Invalid integer: #{string}" if int.to_s != string.to_s.strip
    int
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Parses a symbol from a string.
  # @param string [String] The string to parse.
  # @return [Symbol]
  def params_parse_type_symbol(string)
    string.to_sym
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Parses a color symbol from a string.
  # @param value [String] The string to parse.
  # @return [Symbol] The color as a symbol.
  def params_parse_type_color(value)
    value.to_s.downcase.to_sym
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Parses a subsystem constant from a string.
  # @param string [String] The string to parse.
  # @return [Class] The subsystem class.
  # @raise [RuntimeError] If the string is not a valid subsystem.
  def params_parse_type_subsystem(string)
    subsystem = Liza.const(string)
    raise "#{string.inspect} is not a subsystem" unless subsystem.superclass == Liza::Controller
    subsystem
  rescue Liza::ConstNotFound
    raise "Invalid subsystem: #{string}"
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Prompts the user for a string value for a field.
  # @param field_name [Symbol] The field name.
  # @param default [String] The default value.
  # @return [String] The user input.
  def params_input_type_string(field_name, default)
    InputShell.ask "params[#{field_name.inspect}] - Enter value for string:", default: default
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Prompts the user for a boolean value for a field.
  # @param field_name [Symbol] The field name.
  # @param default [Boolean] The default value.
  # @return [Boolean] The user input.
  def params_input_type_boolean(field_name, default)
    InputShell.yes? "params[#{field_name.inspect}] - Enter value for boolean:", default: !!default
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Prompts the user for an integer value for a field.
  # @param field_name [Symbol] The field name.
  # @param default [Integer] The default value.
  # @return [Integer] The user input.
  def params_input_type_integer(field_name, default)
    InputShell.ask "params[#{field_name.inspect}] - Enter value for integer:", default: default
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Prompts the user to pick a color for a field.
  # @param field_name [Symbol] The field name.
  # @param default [Object] The default value (unused).
  # @return [Symbol] The selected color as a symbol.
  def params_input_type_color(field_name, default)
    InputShell.pick_color string: "I LOVE RUBY"
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Prompts the user for an array value for a field (comma-separated).
  # @param field_name [Symbol] The field name.
  # @param default [Array<String>] The default value.
  # @return [Array<String>] The user input as an array.
  def params_input_type_array(field_name, default)
    InputShell.ask "params[#{field_name.inspect}] - Enter value for array (a,comma,separated,string):", default: default.join(",")
  end

  # This method is dynamically invoked by DevSystem::SimpleCommand::Params using this exact method name.
  # Prompts the user to pick a subsystem for a field.
  # @param field_name [Symbol] The field name.
  # @param default [Object] The default value (unused).
  # @return [String] The selected subsystem key.
  def params_input_type_subsystem(field_name, default)
    available = App.systems.values.map { _1.subsystems.values }.flatten
    length = available.map { _1.singular.to_s.length }.max
    options = available.map do |subsystem|
      key = subsystem.singular.to_s
      color = subsystem.color
      [
        (stick color, "#{key.ljust(length)}      for #{subsystem.to_s}"),
        key
      ]
    end.to_h
    InputShell.pick_one "Select a subsystem:", options
  end

  #
  # Params
  #
  # Provides a declarative, extensible system for defining, parsing, validating, and interacting with command parameters.
  #
  # Features:
  # - Type system: Register and manage parameter types (boolean, string, array, integer, color, subsystem) with custom parsing logic.
  # - Validators: Register and apply custom validators (min, max, range, string size, whitelist, blacklist, email, etc) to fields.
  # - Fields: Define fields with type, mandatory status, default value, and validations. Fields are objects with logic for input, parsing, and validation.
  # - Defaults: Support for default values, both static and via custom methods.
  # - Input handling: Interactive input for missing or required parameters, with per-type and per-field input methods.
  # - Strict mode: Optionally enforce that only explicitly permitted/expected fields are allowed.
  # - Field access: Access field values, types, and objects via methods or dynamic access.
  #
  # Usage:
  #   params = Params.new(command)
  #   params.expect :email, :string, validations: { email: true }
  #   params.permit :age, :integer, default: 18, validations: { min: 0 }
  #   email = params[:email]
  #   age = params[:age]
  #
  # Fields can be accessed as methods (e.g., params.email) or via [].
  # If a field is missing and not in strict mode, it is implicitly permitted as a string.
  # Interactive input is triggered if a value is missing or if ask? is true.
  # Validators raise errors if validation fails.
  #
  class Params
    attr_reader :command

    # Initializes Params with a command instance, parses arguments, and prepares types, validators, and fields.
    # @param command [Object] The command instance using this Params object.
    # @return [void]
    def initialize(command)
      @command = command
      given_strings = command.args.select { |arg| arg.include? "=" }
      given_booleans = command.args.select { |arg| arg.start_with?("+", "-") }

      @args     = command.args - given_strings - given_booleans
      @booleans = given_booleans.map { |arg| [arg[1..-1].to_sym, arg[0]=="+"] }.to_h
      @strings  = given_strings.map { |arg| arg.split "=" }.map { |k,v| [k.to_sym, v] }.to_h

      _prepare_types
      _prepare_validators
      _prepare_fields
    end

    # Registers all built-in types for parameter parsing.
    # @return [void]
    def _prepare_types
      add_type :boolean, parse: false
      add_type :string, parse: false
      add_type :array
      add_type :integer
      add_type :symbol
      add_type :color
      add_type :subsystem
    end

    # Registers all built-in validators for parameter validation.
    # @return [void]
    def _prepare_validators
      add_validator(:min) do |v|
        v[:error] = "#{v[:value].inspect} is lesser than #{v[:reference].inspect}" if v[:value].size < v[:reference]
      end
      add_validator(:max) do |v|
        v[:error] = "#{v[:value].inspect} is greater than #{v[:reference].inspect}" if v[:value].size > v[:reference]
      end
      add_validator(:range) do |v|
        if not v[:value].is_a? Integer
          v[:error] = "#{v[:value].inspect} must be an Integer"
        elsif not v[:value].between?(v[:reference].first, v[:reference].last)
          v[:error] = "#{v[:value].inspect} is outside the range of #{v[:reference].inspect}"
        end
      end
      add_validator(:string_size) do |v|
        v[:error] = "String size #{v[:value].to_s.size} is not equal to #{v[:reference].inspect}" \
          unless v[:value].to_s.size == v[:reference]
      end
      add_validator(:string_size_min) do |v|
        v[:error] = "String size #{v[:value].to_s.size} is lesser than #{v[:reference].inspect}" \
          unless v[:value].to_s.size >= v[:reference]
      end
      add_validator(:string_size_max) do |v|
        v[:error] = "String size #{v[:value].to_s.size} is greater than #{v[:reference].inspect}" \
          unless v[:value].to_s.size <= v[:reference]
      end
      add_validator(:string_size_range) do |v|
        v[:error] = "String size #{v[:value].to_s.size} is outside the range of #{v[:reference].inspect}" \
          unless v[:value].to_s.size.between?(v[:reference].first, v[:reference].last)
      end
      add_validator(:whitelist) do |v|
        v[:error] = "Value not in whitelist: #{v[:reference].inspect}" \
          unless v[:reference].include? v[:value]
      end
      add_validator(:blacklist) do |v|
        v[:error] = "Value in blacklist: #{v[:reference].inspect}" \
          if v[:reference].include? v[:value]
      end
      add_validator(:email) do |v|
        v[:error] = "Invalid email format" unless v[:value] =~ /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/
      end
    end

    # Registers all built-in fields for parameter handling.
    # @return [void]
    def _prepare_fields
      add_field :ask, :boolean, default: false
      add_field :confirm, :boolean, default: false
    end

    # Returns the array of positional arguments.
    # @return [Array<String>]
    attr_reader :args

    # Returns the hash of given boolean parameters.
    # @return [Hash<Symbol, Boolean>]
    attr_reader :booleans

    # Returns the hash of given string parameters.
    # @return [Hash<Symbol, String>]
    attr_reader :strings

    # Returns the hash of registered types.
    # @return [Hash<Symbol, Type>]
    def types
      @types ||= {}
    end

    # Registers a new parameter type.
    # @param type [Symbol] The type name.
    # @param parse [Boolean] Whether to use custom parsing for this type.
    # @return [void]
    def add_type(type, parse: true)
      # log :high, "TYPE     type=#{type.inspect} parse=#{parse.inspect}"
      log_aligned :high, [
        "TYPE",
        "type=#{type.inspect}",
        "parse=#{parse.inspect}"
      ]
      types[type] = Type.new(command, type, parse)
    end

    # Checks if strict mode is enabled.
    # @return [Boolean]
    def strict?
      defined? @strict
    end

    # Enables strict mode (only permitted/expected fields allowed).
    # @return [void]
    def strict!
      @strict = true
      log "params are now strict!"
    end

    # Returns the hash of registered validators.
    # @return [Hash<Symbol, Proc>]
    def validators
      @validators ||= {}
    end

    # Registers a new validator.
    # @param validator [Symbol] The validator name.
    # @yieldparam v [Hash] The validation context (reference, value, error).
    # @return [void]
    def add_validator(validator, &block)
      log :high, "validator=#{validator.inspect} block=#{block&.source_location.inspect}"
      validators[validator] = block
    end

    # Returns the hash of defined fields.
    # @return [Hash<Symbol, Field>]
    def fields
      @fields ||= {}
    end

    # Adds a non-mandatory field.
    # @param name [Symbol] The field name.
    # @param type [Symbol] The type of the field.
    # @param default [Object] The default value.
    # @param validations [Hash] Validations to apply.
    # @return [void]
    def permit(name, type=:string, default: nil, validations: {})
      add_field(name, type, mandatory: false, default:, validations:)
    end

    # Adds a mandatory field.
    # @param name [Symbol] The field name.
    # @param type [Symbol] The type of the field.
    # @param default [Object] The default value.
    # @param validations [Hash] Validations to apply.
    # @return [void]
    def expect(name, type=:string, default: nil, validations: {})
      add_field(name, type, mandatory: true, default:, validations:)
    end

    # Logs an aligned message for debugging.
    # @param log_level [Symbol] The log level.
    # @param array [Array<String>] The message parts.
    # @param blanks [Integer] Padding for alignment.
    # @return [void]
    def log_aligned(log_level=:normal, array, blanks: 15)
      t = array.map do |s|
        s.ljust_blanks(blanks)
      end.join(" ")
      log :high, t, kaller_locations: caller_locations(1,1)
    end

    # Adds a field with the given properties.
    # @param name [Symbol, Integer] The field name or index.
    # @param type [Symbol] The type of the field.
    # @param mandatory [Boolean] Whether the field is required.
    # @param default [Object] The default value.
    # @param validations [Hash] Validations to apply.
    # @return [void]
    def add_field(name, type=:string, mandatory: false, default: nil, validations: {})
      log_aligned [
        "FIELD",
        "name=#{name.inspect}",
        "type=#{type.inspect}",
        "mandatory=#{mandatory.inspect}",
        "default=#{default.inspect}",
        "validations=#{validations.inspect}"
      ]

      index = args.index(name) if name.is_a? Integer

      type = types[type] or raise "Type #{type.inspect} not found. types are #{types.keys.inspect}"

      value = args[name] if name.is_a? Integer
      value ||= booleans[name] if booleans.key? name
      value ||= strings[name] if strings.key? name
      value ||= default
      fields[name] = Field.new(command, name, type, index, value, mandatory:, default:, validations:)
    end

    # Adds a range of fields as an array.
    # @param range [Range] The range of field indices.
    # @param type [Symbol] The type of the fields.
    # @param mandatory [Boolean] Whether the fields are required.
    # @param default [Object] The default value.
    # @param validations [Hash] Validations to apply.
    # @return [void]
    def add_field_range(range, type=:string, mandatory: false, default: nil, validations: {})
      add_field range, :array
      range = range.begin..args.size.pred if range.end.nil? || range.end.negative?
      range.each do |name|
        add_field(name, type, mandatory:, default:, validations:)
      end
    end

    # Sets the default value for a field.
    # @param name [Symbol] The field name.
    # @param value [Object] The default value.
    # @return [void]
    def set_default(name, value)
      field = fields[name]
      raise "Field #{name.inspect} not found" unless field
      log "Setting default of #{name.inspect} to #{value.inspect}"
      field.default = value
    end

    # Retrieves the parsed and validated value for a field.
    # @param name [Symbol, Integer, Range] The field name or index.
    # @return [Object] The field value.
    def [](name)
      object_for(name)
    end

    # Allows dynamic access to fields as methods (e.g., params.email).
    # @param name [Symbol] The method name.
    # @return [Object] The field value or super.
    def method_missing(name, *args, &block)
      name = name[0..-2] if name[-1] == "?"
      if fields.key? name.to_sym
        object_for(name)
      else
        super
      end
    end

    # Checks if a dynamic field method is supported.
    # @param name [Symbol] The method name.
    # @param include_private [Boolean]
    # @return [Boolean]
    def respond_to_missing?(name, include_private = false)
      name = name[0..-2] if name[-1] == "?"
      fields.key?(name) || super
    end

    # Returns the Field object for a given name.
    # @param name [Symbol] The field name.
    # @return [Field]
    def field_for(name)
      fields[name]
    end

    # Returns the Type object for a given field name.
    # @param name [Symbol] The field name.
    # @return [Type]
    def type_for(name)
      raise "Field #{name.inspect} not found" unless fields.key? name
      fields[name].type
    end

    # Returns the raw value for a given field name.
    # @param name [Symbol] The field name.
    # @return [Object]
    def value_for(name)
      raise "Field #{name.inspect} not found" unless fields.key? name
      fields[name].value
    end

    # Retrieves the parsed and validated object for a field, adding it if not present (unless strict mode).
    # @param name [Symbol, Integer, Range] The field name or index.
    # @return [Object] The field value or array of values.
    def object_for(name)
      return @command.ask? if name == :ask
      return @command.confirm? if name == :confirm

      log :high, "object_for #{name.inspect}"
      name = name.to_sym if name.is_a? String
      field_is_args = name.is_a? Integer or name.is_a? Range
      field_is_permitted = fields.key? name
      field_is_named = !field_is_args

      if !field_is_permitted
        # NOTE: In strict-mode, a field must be added or permitted before usage
        if strict?
          qualified = field_is_args
          field_is_added = fields.key? name
          qualified &&= !field_is_added if field_is_named

          raise "Field #{name.inspect} was not added, permitted, or expected (strict mode)" if qualified
        end

        # NOTE: If not strict, we implicitly add the missing field as a string before usage
        permit name, :string
      end

      if name.is_a? Range
        name = name.begin..args.size.pred if name.end.nil? || name.end.negative?
        name.map { object_for _1 }
      else
        fields[name].object
      end
    end

    # Returns the value of the special :ask boolean field.
    # @return [Boolean]
    def ask? ()= command.ask?

    # Returns the value of the special :confirm boolean field.
    # @return [Boolean]
    def confirm? ()= command.confirm?

    # Triggers interactive input for a field.
    # @param field_name [Symbol] The field name.
    # @param default [Object] The default value to use for input.
    # @return [Object] The user-provided value.
    def input(field_name, default: nil)
      field = field_for(field_name)
      raise "Field #{field_name.inspect} not found" unless field
      default ||= field.value
      field.call_input(default)
    end

    # Logs a message with formatting for Params.
    # @param log_level [Symbol] The log level.
    # @param s [String] The message.
    # @param kaller_locations [Array] Call stack locations.
    # @return [void]
    def log(log_level=:normal, s, kaller_locations: caller_locations(1,1))
      s = @command.stick :b, @command.cl.system.color, s
      method_name = "params.#{kaller_locations[0].label.split("#").last}"
      @command.log(log_level, s, method_name:)
    end

    # Logs and raises a StandardError with the given message.
    # @param message [String] The error message.
    # @raise [StandardError]
    def raise(message)
      log message
      super StandardError, message, caller
    end

    # Returns a string representation of the Params object.
    # @return [String]
    def to_s
      inspect
    end

    # Returns a detailed inspection string for Params.
    # @return [String]
    def inspect
      <<~INSPECT
#<Params
  args=#{args.inspect}
  booleans=#{booleans.inspect}
  strings=#{strings.inspect}

  types.keys=#{types.keys.inspect}
  validators.keys=#{validators.keys.inspect}
  fields.keys=#{fields.keys.inspect}>
      INSPECT
    end
  end

  # Type
  #
  # Encapsulates a parameter type definition used by `Params`.
  # The `Type` object knows its name and whether values of this type
  # should be parsed. Parsing is delegated to a method named
  # `params_parse_type_<name>` on the command instance.
  class Type
    attr_reader :name

    # Initialize a Type instance.
    # @param command [Object] the command instance that provides parsers and logging
    # @param name [Symbol] the type name
    # @param parse [Boolean] whether values of this type should be parsed
    # @return [void]
    def initialize(command, name, parse)
      @command = command
      @name = name
      @parse = parse
    end

    # Parse a raw value according to this type.
    # If parsing is disabled for this type, the original value is returned.
    # Parsing is performed by calling `params_parse_type_<name>` on the
    # command instance. This method must exist when `parse?` is true.
    # @param value [Object] raw input value
    # @return [Object] parsed value
    # @raise [RuntimeError] if a parser is required but not defined
    def call(value)
      return value unless parse?
      ret = nil

      method_name = "params_parse_type_#{@name}"
      log "    looking for method #{method_name.inspect}"
      if @command.respond_to?(method_name)
        log "    parsing: #{value.inspect}"
        ret = @command.send(method_name, value)
        log "    parsed:  #{ret.inspect}"
      else
        raise "Parser for type #{@name.inspect} not found! There are 2 ways to define a parser!"
      end
      ret
    end


    # Whether this type should perform parsing.
    # @return [Boolean]
    def parse?
      @parse
    end

    # String inspection for debugging.
    # @return [String]
    def inspect
      "#<Type:#{@name} parse:#{@parse.inspect}>"
    end

    # Log helper scoped to the Type.
    # @param message [String]
    # @return [void]
    def log(message)
      method_name = "params.types[#{@name.inspect}]"
      @command.log :high, message, method_name: method_name
    end
  end

  # Field
  #
  # Encapsulates a parameter field definition used by `Params`.
  # The `Field` object knows its name, type, index (if positional),
  # given value, mandatory status, default value, and validations.
  # It provides methods to handle input, default values, and validation.
  class Field
    attr_accessor :name, :type, :index, :given_value, :mandatory, :default
    attr_reader :validations

    # Initialize a Field instance.
    # @param command [Object] the command instance
    # @param name [Symbol, Integer] the field name or positional index
    # @param type [Type] the Type instance for this field
    # @param index [Integer, nil] positional index (if applicable)
    # @param given_value [Object] the raw value provided by the user (may be nil)
    # @param mandatory [Boolean] whether the field is required
    # @param default [Object] static default value
    # @param validations [Hash] validations to apply
    def initialize(
      command,
      name,
      type,
      index,
      given_value,
      mandatory: false,
      default: nil,
      validations: {}
    )
      raise "Type must not be nil (field #{name.inspect})" if type.nil?
      @command = command
      @name = name
      @type = type
      @index = index
      @given_value = given_value
      @mandatory = mandatory
      @default = default
      @validations = validations
    end

    # Whether interactive prompting is enabled for this field.
    # @return [Boolean]
    def ask?
      @command.ask?
    end

    # Call a custom default value method on the command if present.
    # The method name is `params_default_value_<field_name>`.
    # @return [Object] result of the default method
    def call_default_value
      log "      calling:  #{@command.class}##{method_name_for_default_value}"
      ret = @command.send(method_name_for_default_value)
      log "      returned: #{ret.inspect}"
      ret
    end

    # Whether a custom default value method exists on the command.
    # @return [Boolean]
    def call_default_value?
      log "    looking for method #{method_name_for_default_value.inspect}"
      @command.respond_to? method_name_for_default_value
    end

    # Returns the method name used to fetch a per-field default value.
    # @return [String]
    def method_name_for_default_value
      "params_default_value_#{@name}"
    end

    # Handle interactive input for this field.
    # This will consult per-field and per-type input handlers and
    # respects the `ask?` and `mandatory` flags to decide whether to prompt.
    # @param object [Object] current value (may be nil)
    # @return [Object] value after input handlers
    def call_input(object)
      return object if $testing # during testing, we do not want to ask for input
      return object if !call_input_by_field? and !call_input_by_type? # nothing to do

      object_is_nil = object.nil?
      object_is_not_nil = !object_is_nil
      command_is_asking = ask?
      command_is_not_asking = !command_is_asking

      log "    call_input for field #{@name.inspect} with type #{@type.inspect} and object #{object.inspect}"

      must_return = object_is_not_nil && command_is_not_asking
      log "      must_return=#{must_return.inspect} (object_is_not_nil=#{object_is_not_nil.inspect} && command_is_not_asking=#{command_is_not_asking.inspect})"
      return object if must_return

      must_input = object_is_nil || command_is_asking
      log "      must_input=#{must_input.inspect} (object_is_nil=#{object_is_nil.inspect} || command_is_asking=#{command_is_asking.inspect})"

      return object if !must_input
      log "      must input now!"

      # NOTE: keeping the if-else structure is important to avoid calling both methods
      if call_input_by_field?
        object = call_input_by_field object
      elsif call_input_by_type?
        object = call_input_by_type object
      end

      object
    end

    # Call the per-type input hook on the command: `params_input_type_<type>`.
    # The command method receives `(field_name, default)` and should return the new value.
    # @param object [Object] current default value
    # @return [Object]
    def call_input_by_type(object)
      log "      calling: #{method_name_for_input_by_type.inspect} with default #{object.inspect}"
      ret = @command.send(method_name_for_input_by_type, @name, object)
      log "      returned: #{ret.inspect}"
      if ret.nil? && @mandatory
        log :normal, "      input was nil for mandatory field #{@name.inspect}, asking again..."
        ret = call_input_by_type(object)
      end
      ret
    end

    # Whether a per-type input method exists on the command.
    # @return [Boolean]
    def call_input_by_type?
      log "    looking for method #{method_name_for_input_by_type.inspect}"
      @command.respond_to? method_name_for_input_by_type
    end

    # Returns the per-type input method name for this field.
    # @return [String]
    def method_name_for_input_by_type
      "params_input_type_#{@type.name}"
    end

    # Call the per-field input hook on the command: `params_input_field_<field>`.
    # The command method receives `(default, field_name)` and should return the new value.
    # @param object [Object] current default value
    # @return [Object]
    def call_input_by_field(object)
      log "      calling:  #{method_name_for_input_by_field.inspect} with default #{object.inspect}"
      ret = @command.send(method_name_for_input_by_field, object, @name)
      log "      returned: #{ret.inspect}"
      if ret.nil? && @mandatory
        log :normal, "      input was nil for mandatory field #{@name.inspect}, asking again..."
        ret = call_input_by_field(object)
      end
      ret
    end

    # Whether a per-field input method exists on the command.
    # @return [Boolean]
    def call_input_by_field?
      log "    looking for method #{method_name_for_input_by_field.inspect}"
      @command.respond_to? method_name_for_input_by_field
    end

    # Returns the per-field input method name for this field.
    # @return [String]
    def method_name_for_input_by_field
      "params_input_field_#{@name}"
    end

    # Parse the provided object using a per-field parser, per-type parser, or the Type
    # instance as appropriate. The resolution order is: per-field parser -> per-type parser -> Type.call
    # @param object [Object] value to parse
    # @return [Object] parsed value
    def call_parse(object)
      log "    looking for method #{method_name_for_parse_by_field.inspect}"
      if @command.respond_to? method_name_for_parse_by_field
        call_parse_by_field(object)
      elsif call_parse_by_type?
        call_parse_by_type(object)
      else
        type.call(object)
      end
    end

    # Call the per-field parse hook on the command: `params_parse_field_<field>`.
    # @param object [Object] value to parse
    # @return [Object]
    def call_parse_by_field(object)
      log "      calling:  #{method_name_for_parse_by_field.inspect} with value #{object.inspect}"
      ret = @command.send(method_name_for_parse_by_field, object)
      log "      returned: #{ret.inspect}"
      ret
    rescue StandardError => e
      log "      error: #{e.message}"
      ret = call_input(object)
      ret = call_parse_by_field(ret)
      ret
    end

    # Whether a per-field parse method exists on the command.
    # @return [Boolean]
    def call_parse_by_field?
      log "    looking for method #{method_name_for_parse_by_field.inspect}"
      @command.respond_to? method_name_for_parse_by_field
    end

    # Returns the per-field parse method name for this field.
    # @return [String]
    def method_name_for_parse_by_field
      "params_parse_field_#{@name}"
    end

    # Call the per-type parse hook on the command: `params_parse_type_<type>`.
    # @param object [Object] value to parse
    # @return [Object]
    def call_parse_by_type(object)
      log "      calling:  #{method_name_for_parse_by_type.inspect} with value #{object.inspect}"
      ret = @command.send(method_name_for_parse_by_type, object)
      log "      returned: #{ret.inspect}"
      ret
    rescue StandardError => e
      log "      error: #{e.message}"
      ret = call_input(object)
      ret = call_parse_by_type(ret)
      ret
    end

    # Whether a per-type parse method exists on the command.
    # @return [Boolean]
    def call_parse_by_type?
      log "    looking for method #{method_name_for_parse_by_type.inspect}"
      @command.respond_to? method_name_for_parse_by_type
    end

    # Returns the per-type parse method name for this field.
    # @return [String]
    def method_name_for_parse_by_type
      "params_parse_type_#{@type.name}"
    end

    # Run configured validators for this field against the object.
    # Validators are looked up on `command.params.validators` and are invoked
    # with a context hash `{ reference: <ref>, value: <object>, error: nil }`.
    # Validators may request input again by setting `v[:error]` and then the
    # loop will prompt for input and retry validation.
    # @param object [Object] value to validate
    # @return [Object] possibly updated object after re-validation
    # @raise [RuntimeError] if a validator signals an error that cannot be resolved
    def call_validate(object)
      self.validations.each do |key, arg|
        validator = @command.params.validators[key]
        raise "Validator #{key.inspect} not found in (#{@command.params.validators.keys})" unless validator
        log "    params[#{@name.inspect}] validating #{object.inspect} with params.validators[#{key.inspect}] (#{arg.inspect})"
        v = { reference: arg, value: object }

        validator.call(v)
        while v[:error]
          log :normal, "      validation failed: #{v[:error]} for params[#{@name.inspect}] with value #{v[:value].inspect}, asking for input again..."
          object = call_input(object)
          object = call_parse(object) if object
          v[:value] = object
          v[:error] = nil
          validator.call(v)
        end

        log "      validated with #{key.inspect}"
      end
      object
    end

    # Resolve the raw value for this field, applying static defaults and
    # a per-field default method if present. This does not perform parsing
    # or validation.
    # @return [Object] the resolved raw value
    def value
      return @value if defined? @value

      log "processing value for field #{@name.inspect} with type #{@type.inspect} and given value #{given_value.inspect}"
      # We start with the given value, which can be nil
      value = given_value
      # If value is nil, we try the default value initialized
      value ||= @default
      # If the value is still nil, we try the default value method
      value ||= call_default_value if call_default_value?

      @value = value
    rescue RuntimeError => e
      log "error processing field #{@name.inspect}: #{e.message}"
      raise
    end

    # Returns the final object for this field.
    # This method applies input handlers, parsing and validations in that order.
    # @return [Object] the typed and validated object
    # @raise [RuntimeError] on validation or parsing errors (logged prior to raise)
    def object
      return @object if defined? @object

      log "processing object for field #{@name.inspect} with type #{@type.inspect} and value #{given_value.inspect}"
      log "params[#{@name.inspect}] has 7 processing steps (given value, default value, default method, input field method, input type method, type parsing method, validations)"

      value = self.value

      # First, we handle input
      object = call_input(value)

      # Next, we parse the object
      object = call_parse(object) if object

      # Finally, we validate the object
      object = call_validate(object) if object

      @object = object
    rescue RuntimeError => e
      log "error processing field #{@name.inspect}: #{e.message}"
      raise
    end

    # Log helper scoped to this Field instance.
    # @param message [String]
    # @return [void]
    def log(log_level=:high, message)
      method_name = "params[#{@name.inspect}].#{caller_locations(1,1)[0].label.split("#").last}"
      @command.log log_level, message, method_name:
    end

    # String inspection for debugging.
    # @return [String]
    def inspect
      "#<Field:#{@name} type:#{@type.name}, mandatory:#{@mandatory}, default:#{@default}>"
    end
  end

  section :given

  def given_args = menv[:given_args]

  def given_strings = menv[:given_strings]

  def given_booleans = menv[:given_booleans]

  private

  def before_given
    given_strings  = args.select { |arg| arg.include? "=" }
    given_booleans = args.select { |arg| ["+", "-"].any? { arg.start_with? _1 }  }

    menv[:given_args] = args - given_strings - given_booleans
    menv[:given_strings] = given_strings.map { |arg| arg.split "=" }.map { |k,v| [k.to_sym, v] }.to_h
    menv[:given_booleans] = given_booleans.map { |arg| [arg[1..-1], arg[0]=="+"] }.map { |k,v| [k.to_sym, v] }.to_h

    menv[:given_args].each_with_index { |arg, i| simple_remember_add :arg, i, arg }
    menv[:given_strings].each { |k,v| simple_remember_add :string, k, v }
    menv[:given_booleans].each { |k,v| simple_remember_add :boolean, k, v }
  end

  section :defaults

  public
  
  def ask?
    return @ask if defined? @ask

    ask = default_booleans[:ask]
    ask_arg = given_booleans[:ask]
    ask = ask_arg unless ask_arg.nil?

    @ask = ask
  end

  def confirm?
    return @confirm if defined? @confirm

    confirm = default_booleans[:confirm]
    confirm_arg = given_booleans[:confirm]
    confirm = confirm_arg unless confirm_arg.nil?

    @confirm = confirm
  end

  def default_args
    h = get :default_args
    return h if h

    set :default_args, []
  end

  def set_default_arg(index, value)
    log :highest, "set_default_arg #{index.inspect} #{value.inspect}"
    default_args[index] = value
  end

  def default_strings
    h = get :default_strings
    return h if h

    set :default_strings, {}
  end

  def set_default_string(key, value)
    log :highest, "set_default_string #{key.inspect} #{value.inspect}"
    default_strings[key] = value
  end

  def set_default_array(key, value)
    log :highest, "set_default_array #{key.inspect} #{value.inspect}"
    set_default_string key, value.join(",")
  end

  def default_booleans
    h = get :default_booleans
    return h if h

    set :default_booleans, {}
  end

  def set_default_boolean(key, value)
    log :highest, "set_default_boolean #{key.inspect} #{value.inspect}"
    default_booleans[key] = value
  end

  section :input
  
  def input_args
    h = get :input_args
    return h if h

    set :input_args, []
  end

  def input_strings
    h = get :input_strings
    return h if h

    set :input_strings, {}
  end

  def input_booleans
    h = get :input_booleans
    return h if h

    set :input_booleans, {}
  end

  def set_input_arg(index, &block)
    log :highest, "set_input_arg #{index.inspect} #{block.source_location}"
    input_args[index] = block
  end

  def set_input_string(key, &block)
    log :highest, "set_input_string #{key.inspect}"
    input_strings[key] = block
  end

  def set_input_array(key, &block)
    log :highest, "set_input_array #{key.inspect}"
    set_input_string key do |default|
      block.call(default.to_s.split ",").join ","
    end
  end

  def set_input_boolean(key, &block)
    log :highest, "set_input_boolean #{key.inspect}"
    input_booleans[key] = block
  end

  section :simple

  # Retrieves a simple argument by index if given, then default, then input.
  # 
  # @param index [Integer] The index of the argument to retrieve.
  # @return [String] The argument value determined
  def simple_arg(index)
    arg_given = given_args[index]
    arg_default = default_args[index]
    arg_input = input_args[index]

    arg = arg_given || arg_default
    arg = _arg_input_call(index) if arg_input and (ask? or arg.nil?)

    menv[:simple_args][index] = arg

    arg
  end

  # Retrieves a boolean if given, then default, then input.
  # 
  # @param key [Symbol] The key to retrieve the argument.
  # @return [Boolean] The boolean value determined
  def simple_boolean(key)
    boolean_given = given_booleans[key]
    boolean_default = default_booleans[key]
    boolean_input = input_booleans[key]

    boolean = boolean_given.nil? ? boolean_default : boolean_given
    boolean = _boolean_input_call key if boolean_input and (ask? or boolean.nil?)

    menv[:simple_booleans][key] = boolean

    boolean
  end

  # Retrieves a string if given, then default, then input.
  # 
  # @param key [Symbol] The key to retrieve the argument.
  # @return [String] The string value determined
  def simple_string(key)
    string_given = given_strings[key]
    string_default = default_strings[key]
    string_input = input_strings[key]

    string = string_given || string_default
    string = _string_input_call key if string_input and (ask? or string.nil?)

    menv[:simple_strings][key] = string

    string
  end

  # Retrieves an array of strings if given, then default, then input.
  #
  # @param key [Symbol] The key to retrieve the argument.
  # @return [Array<String>] The array of string values determined.
  def simple_array(key)
    simple_string(key).to_s.split ","
  end

  # Retrieves all simple arguments.
  # 
  # @return [Array<String>] An array of simple arguments.
  def simple_args
    array = []
    [
      default_args,
      given_args,
      menv[:simple_args]
    ].each do |args|
      args.each_with_index do |arg, i|
        array[i] = arg unless arg.nil?
      end
    end
    array
  end

  # Retrieves all simple arguments from the second index onward.
  # 
  # @return [Array<String>] An array of simple arguments offset by 2.
  def simple_args_from_2
    Array simple_args[2..-1]
  end

  # Retrieves all simple boolean arguments.
  # 
  # @return [Hash<Symbol, Boolean>] A hash where each key is a symbol representing a boolean argument.
  def simple_booleans
    given_booleans.merge(default_booleans).merge(menv[:simple_booleans])
  end

  # Retrieves all simple string arguments.
  # 
  # @return [Hash<Symbol, String>] A hash where each key is a symbol representing a string argument.
  def simple_strings
    given_strings.merge(default_strings).merge(menv[:simple_strings])
  end

  private

  def _arg_input_call(index)
    default = given_args[index] || default_args[index]
    value = instance_exec(default, &input_args[index])
    simple_remember_add :arg, index, value
    value
  end

  def _boolean_input_call(key)
    default = given_booleans[key]
    default = default_booleans[key] if default.nil?
    value = instance_exec(default, &input_booleans[key])
    simple_remember_add :boolean, key, value
    value
  end

  def _string_input_call(key)
    default = given_strings[key] || default_strings[key]
    value = instance_exec(default, &input_strings[key])
    simple_remember_add :string, key, value
    value
  end

  def simple_remember
    @simple_remember ||= {args: {}, booleans: {}, strings: {}}
  end

  def simple_remember_add type, key, value
    log :highest, "#{type.inspect}, #{key.inspect}, #{value.inspect}"
    case type
    when :arg
      simple_remember[:args][key] = value
    when :boolean
      simple_remember[:booleans][key] = value
    when :string
      simple_remember[:strings][key] = value
    end
  end

  def simple_remember_values
    simple_remember.values.map { _1.values }.flatten
  end

  def before_simple
    menv[:simple_args] = {}
    menv[:simple_booleans] = {}
    menv[:simple_strings] = {}
  end

  def after_simple
    return unless log? :lower
    return if simple_remember_values.empty?

    log sticks :black, cl.system.color, :b,
      ["LIZA"],
      ["HELPS",    :u],
      ["YOU",      :u, :i],
      ["REMEMBER", :i]
    
    remember = []
    remember << simple_remember[:args].map { |k,v| v.nil? ? nil : v.to_s }.join(" ")
    remember << simple_remember[:booleans].map { |k,v| v.nil? ? nil : (v ? "+#{k}" : "-#{k}") }.join(" ")
    remember << simple_remember[:strings].map { |k,v| v.nil? ? nil : "#{k}=#{v}" }.join(" ")
    remember = remember.reject(&:empty?).join " "
    
    log stick cl.system.color, "#{ $0.split("/").last } #{ menv[:command_arg] } #{ remember }"
  end

  section :simple_derived

  public
  
  # Retrieves the value of an arg key=value.
  # If a block is given and the key is not present,
  # a color picker will be called to select a color.
  # 
  # @param key [Symbol] The key to retrieve from the environment.
  # @param string [String] A prompt string for color selection.
  # @return [Symbol] The selected color as a symbol.
  def simple_color(key, string: "I LOVE RUBY")
    set_input_string key do |_default|
      InputShell.pick_color string: string
    end

    value = simple_string key
    value.to_sym.tap do |color|
      log :low, color.inspect
    end
  end

  # key=value
  def simple_controller_placement(key, places)
    set_input_string key do |_default|
      options = places.map do |place, path|
        [
          "#{place.ljust 30} path: #{path}",
          place
        ]
      end.to_h
      InputShell.pick_one "Where should the controller be placed?", options
    end
    value = simple_string key
    value.tap do |place|
      log :low, place.inspect
    end
  end

  # Prompts the user to input a value for a specific argument by index.
  # 
  # @param index [Integer] The index of the argument to retrieve.
  # @param title [String] The prompt title for user input.
  # @return [String] The user-provided value.
  def simple_arg_ask(index, title)
    set_input_arg index do |default|
      InputShell.ask(title, default: default)
    end
    simple_arg index
  end

  # May prompt the user to input a value for a specific argument by index, enforcing snake_case validation.
  # 
  # @param index [Integer] The index of the argument to retrieve.
  # @param title [String] The prompt title for user input.
  # @param regexp [Regexp] The regular expression for validating input (defaults to /^[a-zA-Z_]*$/).
  # @return [String] The user-provided value in snake_case format.
  def simple_arg_ask_snakecase(index, title, regexp: /^[a-zA-Z_]*$/)
    set_input_arg index do |default|
      InputShell.ask(title, default: default) do |q|
        q.required true
        q.validate regexp
      end.snakecase
    end
    
    simple_arg index
  end

  # May prompt the user (default true) unless arg +key or -key is found.
  # 
  # @param key [Symbol] The key to retrieve the argument.
  # @param title [String] The prompt title for user input.
  # @return [Boolean] The boolean value determined by user input.
  def simple_boolean_yes(key, title)
    set_input_boolean key do |default|
      InputShell.yes? title, default: !!default
    end

    simple_boolean key
  end

  section :simple_composed

  # Sets a default and input method for an argument.
  #
  # @param index [Integer] The index of the argument.
  # @param name [Symbol] The name of the argument.
  # @param default [String] The default value for the argument.
  # @param title [String] The prompt title for the argument.
  # @example
  #   set_arg(0, :file_name, "default.txt", "Enter the file name:")
  def set_arg(index, name, default, title)
    set_default_arg index, name, title
    set_input_arg index, name do |default|
      InputShell.ask title, default: default
    end
  end

  # Sets a default and input method for a boolean.
  #
  # @param name [Symbol] The name of the boolean parameter.
  # @param default [Boolean] The default value for the boolean parameter.
  # @param title [String] The prompt title for the boolean parameter.
  # @example
  #   set_boolean(:overwrite, false, "Do you want to overwrite the file?")
  def set_boolean(name, default, title)
    set_default_boolean name, default
    set_input_boolean name do |default|
      InputShell.yes? title, default: default
    end
  end

  # Sets a default and input method for a string parameter.
  #
  # @param name [Symbol] The name of the string parameter.
  # @param default [String] The default value for the string parameter.
  # @param title [String] The prompt title for the string parameter.
  # @example
  #   set_string(:role, "guest", "Enter your role:")
  def set_string(name, default, title)
    set_default_string name, default
    set_input_string name do |default|
      InputShell.ask title, default: default
    end
  end

end
