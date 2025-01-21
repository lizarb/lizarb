class DevSystem::SimpleCommand < DevSystem::BaseCommand

  section :filters

  def before
    super
    before_given
    before_simple
  end

  def after
    super
    after_simple
  end

  section :given

  def given_args = env[:given_args]

  def given_strings = env[:given_strings]

  def given_booleans = env[:given_booleans]

  private

  def before_given
    given_strings  = args.select { |arg| arg.include? "=" }
    given_booleans = args.select { |arg| ["+", "-"].any? { arg.start_with? _1 }  }

    env[:given_args] = args - given_strings - given_booleans
    env[:given_strings] = given_strings.map { |arg| arg.split "=" }.map { |k,v| [k.to_sym, v] }.to_h
    env[:given_booleans] = given_booleans.map { |arg| [arg[1..-1], arg[0]=="+"] }.map { |k,v| [k.to_sym, v] }.to_h

    env[:given_args].each_with_index { |arg, i| simple_remember_add :arg, i, arg }
    env[:given_strings].each { |k,v| simple_remember_add :string, k, v }
    env[:given_booleans].each { |k,v| simple_remember_add :boolean, k, v }
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

    env[:simple_args][index] = arg

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

    env[:simple_booleans][key] = boolean

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

    env[:simple_strings][key] = string

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
      env[:simple_args]
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
    given_booleans.merge(default_booleans).merge(env[:simple_booleans])
  end

  # Retrieves all simple string arguments.
  # 
  # @return [Hash<Symbol, String>] A hash where each key is a symbol representing a string argument.
  def simple_strings
    given_strings.merge(default_strings).merge(env[:simple_strings])
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
    log :highest, "simple_remember_add #{type.inspect}, #{key.inspect}, #{value.inspect}"
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
    env[:simple_args] = {}
    env[:simple_booleans] = {}
    env[:simple_strings] = {}
  end

  def after_simple
    return unless log? :lower
    return if simple_remember_values.empty?

    log sticks :black, system.color, :b,
      ["LIZA"],
      ["HELPS",    :u],
      ["YOU",      :u, :i],
      ["REMEMBER", :i]
    
    remember = []
    remember << simple_remember[:args].map { |k,v| v.nil? ? nil : v.to_s }.join(" ")
    remember << simple_remember[:booleans].map { |k,v| v.nil? ? nil : (v ? "+#{k}" : "-#{k}") }.join(" ")
    remember << simple_remember[:strings].map { |k,v| v.nil? ? nil : "#{k}=#{v}" }.join(" ")
    remember = remember.reject(&:empty?).join " "
    
    log stick system.color, "#{ $0.split("/").last } #{ env[:command_arg] } #{ remember }"
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
