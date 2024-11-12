class DevSystem::BenchPanel < Liza::Panel

  define_error(:not_found) do |args|
    "bench not found: #{args[0].inspect}"
  end

  #

  def call(command_env)
    env = forge command_env
    find env
    forward env
  rescue Exception => exception
    rescue_from_panel(exception, env)
  end

  #
  
  def forge command_env
    env = {command: command_env[:command]}
    command = env[:command]

    raise_error :not_found, "" if command.args.empty?

    bench_name, bench_action = command.args.first.to_s.split(":")

    env[:bench_name_original] = bench_name
    env[:bench_name] = shortcut(bench_name)
    env[:bench_action_original] = bench_action
    env[:bench_action] = shortcut bench_action || "default"
    log :lower, "bench:action is #{env[:bench_name]}:#{env[:bench_action]}"
    env
  end

  #

  def find env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    raise_error :not_found, "" if env[:bench_name].empty?
    begin
      k = Liza.const "#{env[:bench_name]}_bench"
      log :higher, k
      env[:bench_class] = k
    rescue Liza::ConstNotFound
      raise_error :not_found, env[:bench_name]
    end
  end

  #

  def forward env
    bench_class = env[:bench_class]
    bench_class.call env
  end

end
