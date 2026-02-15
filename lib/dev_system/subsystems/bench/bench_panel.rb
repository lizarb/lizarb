class DevSystem::BenchPanel < Liza::Panel

  define_error(:not_found) do |args|
    "bench not found: #{args[0].inspect}"
  end

  part :command_shortcut, :panel

  section :default

  def call(command_menv)
    menv = forge command_menv
    forge_shortcut menv
    find menv
    find_shortcut menv
    forward menv
  end

  #

  def forge(command_menv)
    command = command_menv[:command]
    bench_name_original, bench_action_original = command.args.first.to_s.split(":")

    menv = { controller: :bench, command:, bench_name_original:, bench_action_original: }

    log :high, "bench_name:bench_action_original is                  #{bench_name_original}:#{bench_action_original}"
    menv
  end

end
