class LabSystem::KrokiDockerShell < LabSystem::DockerShell

  #

  set :port, 9001

  def self.url
    "http://localhost:#{get :port}"
  end

  def self.start_blocking_server
    log "You can visit #{url} for your kroki server"

    port = get :port
    KernelShell.call_backticks "docker run -p#{port}:8000 yuzutech/kroki"

    true
  end

end
