class LabSystem::DockerCommand < DevSystem::Command

  # liza docker

  def self.call args
    log "args = #{args.inspect}"

    log "not implemented"
  end

  # liza docker:kroki

  def self.kroki args
    KrokiDockerShell.start_blocking_server
  end

  # liza docker:hello

  def self.hello args
    t = Time.now
    log "args = #{args.inspect}"

    DockerShell.alpine_hello
  ensure
    log "#{t.diff} | done"
  end

  # liza docker:version

  def self.version args
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
