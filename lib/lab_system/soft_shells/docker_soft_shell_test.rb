class LabSystem::DockerSoftShellTest < DevSystem::SoftShellTest

  section :subject

  test :subject_class, :subject do
    assert_equality subject_class, LabSystem::DockerSoftShell
    assert_equality subject.class, LabSystem::DockerSoftShell
  end

  test :parse_version do
    output = render :docker_version, format: :txt
    h = subject_class.parse_version output

    assert_equality h.keys, ["Client", "Server"]
    # I mostly wanted to start a conversation about which version of docker we should be support.
    assert_equality h.dig("Client", "Name"), "Docker Engine - Community"
    assert_equality h.dig("Server", "Name"), "Docker Engine - Community"

    assert_equality h["Client"].keys, ["Name", "Version", "API version", "Go version", "Git commit", "Built", "OS/Arch", "Context"]
    assert_equality h["Server"].keys, ["Name", "Engine", "containerd", "runc", "docker-init"]
    
    assert_equality h["Server"]["Engine"].keys,      ["Version", "API version", "Go version", "Git commit", "Built", "OS/Arch", "Experimental"]
    assert_equality h["Server"]["containerd"].keys,  ["Version", "GitCommit"]
    assert_equality h["Server"]["runc"].keys,        ["Version", "GitCommit"]
    assert_equality h["Server"]["docker-init"].keys, ["Version", "GitCommit"]
  end

end

__END__

# view docker_version.txt.erb

Client: Docker Engine - Community
 Version:           24.0.6
 API version:       1.43
 Go version:        go1.20.7
 Git commit:        ed223bc
 Built:             Mon Sep  4 12:31:44 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          24.0.6
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.7
  Git commit:       1a79695
  Built:            Mon Sep  4 12:31:44 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.24
  GitCommit:        61f9fd88f79f081d64d6fa3bb1a0dc71ec870523
 runc:
  Version:          1.1.9
  GitCommit:        v1.1.9-0-gccaecfc
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
