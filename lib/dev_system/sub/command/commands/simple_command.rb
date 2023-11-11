class DevSystem::SimpleCommand < DevSystem::BaseCommand

  #

  def call(env)
    env[:simple] = [""]
    super
  end

  #

  def log_simple_remember
    log :lower, "env[:remember] is now #{stick system.color, (env[:simple].join " ")}", kaller: caller
  end
  
  #

  # key=value
  def simple_string(key, &block)
    string = env[:args].find { _1.start_with? "#{key}=" }.to_s.sub("#{key}=", "")
    return string unless string.empty?

    value = yield.to_s.split(" ")[0]
    log :high, value.inspect

    env[:simple] << "#{key}=#{value}"

    log_simple_remember

    value
  end

  #

  def simple_color(key, string: "I LOVE RUBY")
    simple_string key do
      TtyInputCommand.pick_color string: string
    end.to_sym.tap do |color|
      log :high, color.inspect
    end
  end

end
