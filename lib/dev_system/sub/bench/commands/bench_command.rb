class DevSystem::BenchCommand < DevSystem::SimpleCommand

  # liza bench NAME
  def call_default
    log :higher, "env.count is #{env.count}"
    DevBox.bench env
  end

end
