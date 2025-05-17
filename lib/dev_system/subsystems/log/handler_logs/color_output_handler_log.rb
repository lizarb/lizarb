class DevSystem::ColorOutputHandlerLog < DevSystem::OutputHandlerLog
  
  def self.sidebar_for menv
    sidebar = ""

    source = menv[:unit_class]
    system_color = source.system.color || :white
    source_color = source.color || :white
    size = 0

    # TODO: Figure out why RequestPanel is returning false when started from rack command but not from request command
    # source_is_a_panel = source < Panel
    # source_is_a_panel = source.ancestors.include? Panel
    # source_is_a_panel = menv[:unit].is_a? Panel
    source_is_a_panel = source.to_s.end_with? "Panel"

    if source_is_a_panel
      namespace, _sep, classname = menv[:unit_class].controller.name.rpartition('::')
      unless namespace.empty?
        sidebar << stick(namespace, system_color, :b).to_s
        sidebar << "::"
        size += namespace.size + 2
      end
      sidebar << stick(classname, source_color, :b).to_s
      size += classname.size

      sidebar << ".panel."
      size += 7
    else
      method_sep = menv[:instance] ? "#" : ":"

      namespace, _sep, classname = menv[:unit_class].name.rpartition('::')
      unless namespace.empty?
        sidebar << stick(namespace, system_color, :b).to_s
        sidebar << "::"
        size += namespace.size + 2
      end
      sidebar << stick(classname, source_color, :b).to_s

      sidebar << method_sep
      size += classname.size + 1
    end

    sidebar << menv[:method_name]
    size += menv[:method_name].size

    size = DevBox[:log].sidebar_size - size - 1
    size = 0 if size < 0
    sidebar << " " * size

    sidebar
  rescue => e
    puts e
    binding.irb
  end

end
