class DevSystem::SimpleCommand < DevSystem::SimplerCommand

  section :filters

  def before
    super
  end

  def after
    super
    # must be defined here
  end

  section :default
  
  # Retrieves the value of an arg key=value.
  # If a block is given and the key is not present,
  # a color picker will be called to select a color.
  # 
  # @param key [Symbol] The key to retrieve from the environment.
  # @param string [String] A prompt string for color selection.
  # @return [Symbol] The selected color as a symbol.
  def simple_color(key, string: "I LOVE RUBY")
    set_input_string key do |_default|
      TtyInputCommand.pick_color string: string
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
      TtyInputCommand.pick_one "Where should the controller be placed?", options
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
      TtyInputCommand.prompt.ask(title, default: default)
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
      TtyInputCommand.prompt.ask(title, default: default) do |q|
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
      TtyInputCommand.prompt.yes? title, default: !!default
    end

    simple_boolean key
  end

  # May prompt the user (default false) unless arg +key or -key is found.
  # 
  # @param key [Symbol] The key to retrieve the argument.
  # @param title [String] The prompt title for user input.
  # @return [Boolean] The boolean value determined by user input.
  def simple_boolean_no(key, title)
    set_input_boolean key do |default|
      TtyInputCommand.prompt.no? title
    end
    simple_boolean key
  end

end
