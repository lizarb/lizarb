class DevSystem::OutputLog < DevSystem::Log

  SIDEBAR_LENGTH = 60
  
  def self.call(env)
    env[:sidebar] ||= sidebar_for env

    string = env[:object]
    string = string.join("") if string.is_a? Array

    unless $coding
      pid = Process.pid
      tid = Lizarb.thread_id.to_s.rjust_zeroes 3
      env[:sidebar] = "#{pid} #{tid} #{env[:sidebar]}"
    end

    string = "#{env[:sidebar]} #{string}"
    Kernel.puts string
  end
  
  def self.sidebar_for env
    sidebar = ""

    source = env[:unit_class]
    source_color = source.log_color
    system_color = source.system.log_color
    size = 0

    # TODO: Figure out why RequestPanel is returning false when started from rack command but not from request command
    # source_is_a_panel = source < Panel
    # source_is_a_panel = source.ancestors.include? Panel
    # source_is_a_panel = env[:unit].is_a? Panel
    source_is_a_panel = source.to_s.end_with? "Panel"

    if source_is_a_panel
      key = env[:unit].key
      source = source.box

      namespace, _sep, classname = source.name.rpartition('::')
      unless namespace.empty?
        sidebar << namespace.colorize(system_color)
        sidebar << "::"
        size += namespace.size + 2
      end
      sidebar << classname.colorize(source_color)
      sidebar << "[:#{key}]."

      size += classname.size + key.size + 4
    else
      method_sep = env[:instance] ? "#" : ":"

      namespace, _sep, classname = env[:unit_class].name.rpartition('::')
      unless namespace.empty?
        sidebar << namespace.colorize(system_color)
        sidebar << "::"
        size += namespace.size + 2
      end
      sidebar << classname.colorize(source_color)

      sidebar << method_sep
      size += classname.size + 1
    end

    sidebar << env[:method_name]
    size += env[:method_name].size

    size = SIDEBAR_LENGTH - size - 1
    size = 0 if size < 0
    sidebar << " " * size

    sidebar
  end

end