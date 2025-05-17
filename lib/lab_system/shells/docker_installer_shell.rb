class LabSystem::DockerInstallerShell < DevSystem::Shell
  
  # LabSystem::DockerInstallerShell.call({})
  # LabSystem::DockerInstallerShell.call(menv)
  
  def self.call(menv)
    raise "Not implemented for #{ os }" unless linux?
    super(menv)

    log stick system.color, "Install Docker ".ljust(80, "-")

    if is_installed?
      log "Docker is already installed"
      return
    else
      log "Docker is not installed"
    end
    
    docker_keyring_path = "/usr/share/keyrings/docker-archive-keyring.gpg"
    docker_list_path = "/etc/apt/sources.list.d/docker.list"

    if FileShell.exist? docker_keyring_path
      log "The stable repository is already added"
    else
      log "Add Docker’s official GPG key"
      sh "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o #{docker_keyring_path}"
    end
  
    if FileShell.exist? docker_list_path
      log "The stable repository is already added"
    else
      log "Add the stable repository"
      sh "echo \"deb [arch=$(dpkg --print-architecture) signed-by=#{docker_keyring_path}] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" | sudo tee #{ docker_list_path } > /dev/null"
    end

    log "Update them packages"
    sh "sudo apt-get update"

    log "Install Docker"
    sh "sudo apt install docker-ce docker-ce-cli containerd.io -y"

    log "Add your user to the docker group"
    sh "sudo usermod -aG docker $USER"

    log "Start and enable the Docker service"
    sh "sudo systemctl start docker"
    sh "sudo systemctl enable docker"

    if is_installed?
      log "Docker is installed!"
    else
      log "Docker has not been installed"
      return
    end

    log "testing docker with hello-world"
    sh "sudo docker run hello-world"
  end if linux?

  def self.is_installed?
    log "Checking Docker version"
    sh "sudo docker --version"
  end
  
  def self.sh(s)
    KernelShell.call_system s
  end

end
