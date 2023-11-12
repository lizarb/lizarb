class DevSystem::TextFileShell < DevSystem::FileShell

  #

  attr_reader :old_lines, :relative_path, :path
  attr_accessor :new_lines

  def initialize(path)
    @path = Pathname(path)
    @relative_path = Pathname(path).relative_path_from(App.root)
    @old_lines = TextShell.read_lines path
  end

end
