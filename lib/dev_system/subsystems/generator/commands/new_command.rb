class DevSystem::NewCommand < DevSystem::SimpleCommand

  # liza new [app_name]

  def call_default
    call_project
  end

  # liza new:sfa [app_name]

  def call_sfa
    log :higher, "env.count is #{env.count}"
    args = env[:args] = ["new:sfa", *env[:args]]
    log "args = #{args.inspect}"
    DevBox[:generator].call env
  end

  # liza new:project [app_name]

  def call_project
    log :higher, "env.count is #{env.count}"
    args = env[:args] = ["new", *env[:args]]
    log "args = #{args.inspect}"
    DevBox[:generator].call env
  end

  # liza new:script [app_name]

  def call_script
    log :higher, "env.count is #{env.count}"
    args = env[:args] = ["new:script", *env[:args]]
    log "args = #{args.inspect}"
    DevBox[:generator].call env
  end

end
