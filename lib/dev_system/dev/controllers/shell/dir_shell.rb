class DevSystem::DirShell < DevSystem::FileShell

  # OVERRIDES

  def self.exist? path
    log :normal, "Checking if directory exists at '#{path}'"

    directory? path
  end

  def self.size path
    log :normal, "Getting size of directory at '#{path}'"
    _raise_if_not_exists path

    Pathname.new(path).children.inject(0) { |sum, f| sum + f.size }
  end

  # CUSTOM

  def self.create path
    log :normal, "Creating directory at '#{path}'"
    _raise_if_blank path

    Pathname.new(path).mkpath
  end

end
