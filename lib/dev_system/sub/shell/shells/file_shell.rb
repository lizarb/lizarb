class DevSystem::FileShell < DevSystem::Shell

  def self._raise_if_blank path
    raise ArgumentError, "Path is required" if path.nil? || path.to_s.empty?
  end

  def self._raise_if_not_exists path
    raise ArgumentError, "File does not exist at '#{path}'" unless exist? path
  end

  #

  def self.exist? path
    log :normal, "Checking if file exists at '#{path}'"
    _raise_if_blank path

    File.exist? path
  end

  def self.size path
    log :normal, "Getting size of file at '#{path}'"
    _raise_if_not_exists path

    File.size path
  end

  #

  def self.directory? path
    log :normal, "Checking if '#{path}' is a directory"
    _raise_if_blank path

    File.directory? path
  end

  def self.file? path
    log :normal, "Checking if '#{path}' is a file"
    _raise_if_blank path

    File.file? path
  end

  #

  def self.touch path
    log :normal, "Touching '#{path}'"
    _raise_if_blank path

    dir = File.dirname(path)
    DevSystem::DirShell.create dir

    FileUtils.touch path
  end

  def self.gitkeep path
    touch "#{path}/.gitkeep"
  end

end
