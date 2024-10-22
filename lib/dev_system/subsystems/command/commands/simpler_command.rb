class DevSystem::SimplerCommand < DevSystem::BaseCommand

  section :filters

  def before
    before_given
  end

  def after
    # must be defined here
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

  def set_input_boolean(key, &block)
    log :highest, "set_input_boolean #{key.inspect}"
    input_booleans[key] = block
  end

end
