class DevSystem::SimpleCommand < DevSystem::BaseCommand

  #

  def call(env)
    env[:simple] = [""]
    super
  end

  #

  def log_simple_remember
    log :higher, "env[:remember] is now #{stick system.color, (env[:simple].join " ")}", kaller: caller
  end
  
  # 

  # key=value
  def simple_string(key, &block)
    string = env[:args].find { _1.start_with? "#{key}=" }.to_s.sub("#{key}=", "")
    return string unless string.empty?

    value = yield.to_s.split(" ")[0]
    log :low, value.inspect

    env[:simple] << "#{key}=#{value}"

    log_simple_remember

    value
  end

  #

  # key=value
  def simple_color(key, string: "I LOVE RUBY")
    simple_string key do
      TtyInputCommand.pick_color string: string
    end.to_sym.tap do |color|
      log :low, color.inspect
    end
  end

  #

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

  #

  # arg0 arg1 arg2
  def simple_args
    env[:args]
      .reject { _1.start_with? "+" }
      .reject { _1.start_with? "-" }
      .reject { _1.include? "=" }
  end

  # arg0 arg1 arg2
  def simple_arg(index, &block)
    string = env[:args][index]
    return string if string

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

  #

  # arg0 arg1 arg2
  def simple_arg_ask(index, title)
    simple_arg index do
      TtyInputCommand.prompt.ask(title)
    end
  end

  #

  # arg0 arg1 arg2
  def simple_arg_ask_snakecase(index, title, regexp: /^[a-zA-Z_]*$/)
    simple_arg index do
      TtyInputCommand.prompt.ask(title) do |q|
        q.required true
        q.validate regexp
      end.snakecase
    end
  end

  #

  # +key -key
  def simple_boolean_yes(key, title)
    simple_boolean key do
      TtyInputCommand.prompt.yes? title
    end
  end

  # +key -key
  def simple_boolean_no(key, title)
    simple_boolean key do
      TtyInputCommand.prompt.no? title
    end
  end

  # +key -key
  def simple_boolean(key, &block)
    return true  if env[:args].find { _1 == "+#{key}" }
    return false if env[:args].find { _1 == "-#{key}" }

    value = yield
    log :low, value.inspect

    env[:simple] << "+#{key}" if TrueClass === value
    env[:simple] << "-#{key}" if FalseClass === value

    log_simple_remember

    value
  end

end
