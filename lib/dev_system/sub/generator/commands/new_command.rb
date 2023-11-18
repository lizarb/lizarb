class DevSystem::NewCommand < DevSystem::SimpleCommand

  def call_default
    log :lower, "env.count is #{env.count}"
    args = env[:args] = ["new", *env[:args]]
    log "args = #{args.inspect}"
    DevBox[:generator].call env
  end

end