class DevSystem::SimpleCommand < DevSystem::BaseCommand

  def before
    simple_strings  = args.select { |arg| arg.include? "=" }
    simple_booleans = args.select { |arg| ["+", "-"].any? { arg.start_with? _1 }  }

    env[:simple] = [""]
    env[:simple_args] = args - simple_strings - simple_booleans
    env[:simple_strings] = simple_strings.map { |arg| arg.split "=" }.map { |k,v| [k.to_sym, v] }.to_h
    env[:simple_booleans] = simple_booleans.map { |arg| [arg[1..-1], arg[0]=="+"] }.map { |k,v| [k.to_sym, v] }.to_h
  end

  # Logs the current state of the :remember key in the environment.
  def log_simple_remember
    log :higher, "env[:remember] is now #{stick system.color, (env[:simple].join " ")}", kaller: caller
  end
  
  # Retrieves the value of an arg key=value.
  # If a block is given and the key is not present,
  # the block's result is used as the value.
  # 
  # @param key [Symbol] The key to retrieve from the environment.
  # @yield [String] A block to generate a value if the key is not present.
  # @return [String] The value associated with the key or the result of the block if the key is absent.
  def simple_string(key)
    # Find the value associated with the key in simple_strings.
    string = simple_strings[key.to_sym]
    log "#{key}=#{string.inspect}"

    # If no block is given or a value is already found, return the value.
    return string unless block_given?

    # If the value is not present and a block is given, compute the new value.
    return string if string

    value = yield.to_s.split(" ").first
    log :low, value.inspect

    # Remember this value
    env[:simple] << "#{key}=#{value}"
    log_simple_remember

    value
  end

  # Retrieves the value of an arg key=value.
  # If a block is given and the key is not present,
  # a color picker will be called to select a color.
  # 
  # @param key [Symbol] The key to retrieve from the environment.
  # @param string [String] A prompt string for color selection.
  # @return [Symbol] The selected color as a symbol.
  def simple_color(key, string: "I LOVE RUBY")
    simple_string key do
      TtyInputCommand.pick_color string: string
    end.to_sym.tap do |color|
      log :low, color.inspect
    end
  end

  # key=value
  def simple_controller_placement(key, places)
    simple_string key do
      options = places.map do |place, path|
        [
          "#{place.ljust 30} path: #{path}",
          place
        ]
      end.to_h
      TtyInputCommand.pick_one "Where should the controller be placed?", options
    end.tap do |place|
      log :low, place.inspect
    end
  end

  # Returns all simple arguments (i.e., args that are not key=value or +key/-key).
  # 
  # @return [Array<String>] An array of simple arguments.
  def simple_args()= env[:simple_args]

  # Retrieves all simple boolean arguments from the environment.
  # 
  # @return [Hash<Symbol, Boolean>] A hash where each key is a symbol representing a boolean argument.
  def simple_booleans()= env[:simple_booleans]

  # Retrieves all simple string arguments from the environment.
  # 
  # @return [Hash<Symbol, String>] A hash where each key is a symbol representing a string argument.
  def simple_strings()= env[:simple_strings]

  # Retrieves the value of a specific simple argument by index.
  # If the argument is not present, a block will be executed to generate a value.
  # 
  # @param index [Integer] The index of the argument to retrieve.
  # @yield [String] A block to generate a value if the argument is not present.
  # @return [String] The argument value or the result of the block if the argument is absent.
  def simple_arg(index, &block)
    # Find the value associated with the index in simple_args.
    string = simple_args[index]
    s = simple_args.map.with_index { |arg, i| i == index ? "[#{arg}]" : arg }.join " "
    log "index #{index}: #{s}"

    # If no block is given or a value is already found, return the value.
    return string if string
    return string unless block_given?

    value = yield
    value = "" if value.nil?
    value = value.inspect if value.include? " "
    log :low, value.inspect

    string = env[:simple][0]
    string << " " unless string.empty?
    string << value

    log_simple_remember

    value
  end

  # Prompts the user to input a value for a specific argument by index.
  # 
  # @param index [Integer] The index of the argument to retrieve.
  # @param title [String] The prompt title for user input.
  # @return [String] The user-provided value.
  def simple_arg_ask(index, title)
    simple_arg index do
      TtyInputCommand.prompt.ask(title)
    end
  end

  # May prompt the user to input a value for a specific argument by index, enforcing snake_case validation.
  # 
  # @param index [Integer] The index of the argument to retrieve.
  # @param title [String] The prompt title for user input.
  # @param regexp [Regexp] The regular expression for validating input (defaults to /^[a-zA-Z_]*$/).
  # @return [String] The user-provided value in snake_case format.
  def simple_arg_ask_snakecase(index, title, regexp: /^[a-zA-Z_]*$/)
    simple_arg index do
      TtyInputCommand.prompt.ask(title) do |q|
        q.required true
        q.validate regexp
      end.snakecase
    end
  end

  # May prompt the user (default true) unless arg +key or -key is found.
  # 
  # @param key [Symbol] The key to retrieve the argument.
  # @param title [String] The prompt title for user input.
  # @return [Boolean] The boolean value determined by user input.
  def simple_boolean_yes(key, title)
    simple_boolean key do
      TtyInputCommand.prompt.yes? title
    end
  end

  # May prompt the user (default false) unless arg +key or -key is found.
  # 
  # @param key [Symbol] The key to retrieve the argument.
  # @param title [String] The prompt title for user input.
  # @return [Boolean] The boolean value determined by user input.
  def simple_boolean_no(key, title)
    simple_boolean key do
      TtyInputCommand.prompt.no? title
    end
  end

  # Retrieves true or false if arg +key or -key
  # If a block is given and the key is not present,
  # the block's result is used as the value.
  # 
  # @param key [Symbol] The key to retrieve the argument.
  def simple_boolean(key, &block)
    return simple_booleans[key] if simple_booleans.key? key
    return false unless block_given?

    value = yield
    log :low, value.inspect

    env[:simple] << "+#{key}" if TrueClass === value
    env[:simple] << "-#{key}" if FalseClass === value
    log_simple_remember

    value
  end

end
