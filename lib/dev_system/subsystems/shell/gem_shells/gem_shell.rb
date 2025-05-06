class DevSystem::GemShell < DevSystem::Shell
  division!

  def self.gems
    @gems ||= {}
  end

  def self.gem(
    name,
    *versions,
    require: nil,
    git: nil,
    github: nil,
    gitlab: nil,
    bitbucket: nil,
    branch: nil,
    tag: nil,
    commit: nil,
    path: nil,
    group: nil,
    platforms: nil,
    aptitude: nil,
    pacman: nil,
    dnf: nil
  )
    # git, github, gitlab, bitbucket, and path are mutually exclusive
    if [git, github, gitlab, bitbucket, path].compact.size > 1
      raise ArgumentError, "Only one of :git, :github, :gitlab, :bitbucket, or :path can be specified"
    end

    self.require require || name

    gems[name] = {versions:, require:, git:, github:, gitlab:, bitbucket:, branch:, tag:, commit:, path:, group:, platforms:, aptitude:, pacman:, dnf:,}
  end
  
end
