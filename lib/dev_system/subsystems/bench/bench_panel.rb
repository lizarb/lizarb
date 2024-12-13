class DevSystem::BenchPanel < Liza::Panel

  define_error(:not_found) do |args|
    "bench not found: #{args[0].inspect}"
  end

  part :command_shortcut, :panel

  section :default

  def call(command_env)
    env = forge command_env
    forge_shortcut env
    find env
    find_shortcut env
    forward env
  end

  #
  
  def forge(command_env)
    command = command_env[:command]
    bench_name_original, bench_action_original = command.args.first.to_s.split(":")

    env = { controller: :bench, command:, bench_name_original:, bench_action_original: }

    log :high, "bench_name:bench_action_original is                  #{bench_name_original}:#{bench_action_original}"
    env
  end

end
