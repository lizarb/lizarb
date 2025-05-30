class DevSystem::DirShell < DevSystem::FileShell

  # OVERRIDES

  def self.exist? path, log_level: self.log_level
    log log_level, "Checking if directory exists at '#{path}'"

    directory? path
  end

  def self.size path, log_level: self.log_level
    log log_level, "Getting size of directory at '#{path}'"
    _raise_if_not_exists path

    Pathname(path).children.inject(0) { |sum, f| sum + f.size }
  end

  # CUSTOM

  def self.create path, log_level: self.log_level
    log log_level, "Creating directory at '#{path}'"
    _raise_if_blank path

    Pathname(path).mkpath
  end

end
