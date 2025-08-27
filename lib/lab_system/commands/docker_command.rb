class LabSystem::DockerCommand < DevSystem::SimpleCommand

  # liza docker

  def call_default
    log "args = #{args.inspect}"

    log "not implemented"
  end

  # liza docker:install

  def call_install
    DockerInstallerShell.call(menv)
  end

  # liza docker:hello

  def call_hello
    t = Time.now
    log "args = #{args.inspect}"

    DockerShell.hello_alpine
  ensure
    log "#{time_diff t} | done"
  end

  # liza docker:version

  def call_version
    log "args = #{args.inspect}"

    h = DockerShell.version

    log "h.keys = #{h.keys.inspect}"

    puts

    log "Client"

    log_hash h["Client"]

    puts

    log "Server"
    log "Name = #{h["Server"]["Name"]}"
    puts
    log "Engine"
    log_hash h["Server"]["Engine"]
    puts
    log "containerd"
    log_hash h["Server"]["containerd"]
    puts
    log "runc"
    log_hash h["Server"]["runc"]
    puts
    log "docker-init"
    log_hash h["Server"]["docker-init"]
  end

end
