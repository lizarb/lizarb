class DevSystem::ColorOutputHandlerLog < DevSystem::OutputHandlerLog
  
  def self.sidebar_for env
    sidebar = ""

    source = env[:unit_class]
    system_color = source.system.color
    source_color = source.color
    source_color = source.system.color if source < DevSystem::BoxTest
    size = 0

    # TODO: Figure out why RequestPanel is returning false when started from rack command but not from request command
    # source_is_a_panel = source < Panel
    # source_is_a_panel = source.ancestors.include? Panel
    # source_is_a_panel = env[:unit].is_a? Panel
    source_is_a_panel = source.to_s.end_with? "Panel"

    if source_is_a_panel
      key = env[:unit].key
      source = source.box

      _namespace, _sep, classname = source.name.rpartition('::')
      sidebar << stick(classname, source_color).to_s
      sidebar << "[:#{key}]."

      size += classname.size + key.size + 4
    else
      method_sep = env[:instance] ? "#" : ":"

      namespace, _sep, classname = env[:unit_class].name.rpartition('::')
      unless namespace.empty?
        sidebar << stick(namespace, system_color, :b).to_s
        sidebar << "::"
        size += namespace.size + 2
      end
      sidebar << stick(classname, source_color, :b).to_s

      sidebar << method_sep
      size += classname.size + 1
    end

    sidebar << env[:method_name]
    size += env[:method_name].size

    size = DevBox[:log].sidebar_size - size - 1
    size = 0 if size < 0
    sidebar << " " * size

    sidebar
  end

end
