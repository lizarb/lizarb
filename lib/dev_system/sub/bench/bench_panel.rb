class DevSystem::BenchPanel < Liza::Panel

  define_error(:not_found) do |args|
    "bench not found: #{args[0].inspect}"
  end

  #

  def call env
    log :high, "env.count is #{env.count}"
    parse env
    find env
    forward env
  rescue Exception => exception
    rescue_from_panel(exception, env)
  end

  #

  def parse env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
    raise_error :not_found, "" if env[:args].none?

    bench_name, bench_action = env[:args].first.split(":").map(&:to_sym)

    env[:bench_name_original] = bench_name
    env[:bench_name] = short(bench_name).to_sym
    env[:bench_action_original] = bench_action
    env[:bench_action] = bench_action
    log :lower, "bench:action is #{env[:bench_name]}:#{env[:bench_action]}"
  end

  #

  def find env
    if log_level? :high
      puts
      log "env.count is #{env.count}"
    end
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
