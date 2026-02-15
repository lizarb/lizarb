class DevSystem::FileShell < DevSystem::Shell

  set :create_dir, true

  def self._raise_if_blank path
    raise ArgumentError, "Path is required" if path.nil? || path.to_s.empty?
  end

  def self._raise_if_not_exists path, log_level: self.log_level
    raise ArgumentError, "File does not exist at '#{path}'" unless exist?(path, log_level: log_level)
  end

  #

  def self.exist? path, log_level: self.log_level
    log log_level, "Checking if file exists at '#{path}'"
    _raise_if_blank path

    File.exist? path
  end

  def self.size path, log_level: self.log_level
    log log_level, "Getting size of file at '#{path}'"
    _raise_if_not_exists path

    File.size path
  end

  # category

  def self.directory? path, log_level: self.log_level
    log log_level, "Checking if '#{path}' is a directory"
    _raise_if_blank path

    File.directory? path
  end

  def self.file? path, log_level: self.log_level
    log log_level, "Checking if '#{path}' is a file"
    _raise_if_blank path

    File.file? path
  end

  def self.symbolic_link? path, log_level: self.log_level
    log log_level, "Checking if '#{path}' is a symbolic link"
    _raise_if_blank path

    File.symlink? path
  end

  def self.category_for path, log_level: self.log_level
    log log_level, "Getting category for '#{path}'"
    _raise_if_blank path

    return :directory     if directory?     path, log_level: :highest
    return :file          if file?          path, log_level: :highest
    return :symbolic_link if symbolic_link? path, log_level: :highest
  end

  #

  def self.touch path, log_level: self.log_level
    log log_level, "Touching '#{path}'"
    _raise_if_blank path

    dir = File.dirname(path)
    DevSystem::DirShell.create dir

    File.open(path, "w").close

    true
  end

  def self.gitkeep path
    touch "#{path}/.gitkeep"
  end

  # read

  def self.read_binary(path, log_level: self.log_level)
    # TODO: move all code from BinShell to this file
    BinShell.read path
  end

  def self.read_text(path, log_level: self.log_level)
    log log_level, "Reading #{path}"
    _raise_if_blank path
    _raise_if_not_exists path, log_level:

    File.read path
  end

  def self.read_lines path, log_level: self.log_level
    log log_level, "Reading lines from #{path}"
    return [] unless exist? path, log_level: log_level
    _raise_if_blank path

    File.readlines path
  end

  def self.read_lines! path, log_level: self.log_level
    log log_level, "Reading lines from #{path}"
    _raise_if_blank path
    _raise_if_not_exists path

    File.readlines path
  end

  # write

  def self.write_binary(path, content, create_dir: nil, log_level: self.log_level)
    # TODO: move all code from BinShell to this file
    BinShell.write path, content, create_dir:
  end

  def self.write_text(path, content, create_dir: nil, log_level: self.log_level)
    log log_level, "#{ stick system.color, "Writing" } #{content.to_s.size} characters (#{content.encoding}) to #{path}"
    _raise_if_blank path

    create_dir = get :create_dir if create_dir.nil?
    DevSystem::DirShell.create File.dirname(path), log_level: log_level if create_dir

    File.write path, content
  end

  def self.copy(source, destination, log_level: self.log_level)
    log log_level, "Copying '#{source}' to '#{destination}'"
    source = Pathname(source)
    destination = Pathname(destination)
    _raise_if_blank source
    _raise_if_blank destination

    if source.directory?
      destination.mkpath
      source.each_child do |child|
        copy(child, destination.join(child.basename))
      end
    else
      destination.dirname.mkpath # Ensure the destination directory exists
      File.open(destination, "wb") do |dest_file|
        File.open(source, "rb") do |src_file|
          dest_file.write(src_file.read)
        end
      end
    end
  end

  def self.remove(path, log_level: self.log_level)
    log log_level, "Removing '#{path}'"
    _raise_if_blank path

    if exist? path, log_level: log_level
      File.delete path
      true
    else
      false
    end
  end

end
