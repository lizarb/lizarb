class DevSystem::OutputHandlerLog < DevSystem::HandlerLog

  def self.call(env)
    super
    sidebar = env[:sidebar] || (sidebar_for env)

    unless $coding
      pid = Process.pid
      tid = Lizarb.thread_id.to_s.rjust_zeroes 3
      sidebar = "#{pid} #{tid} #{sidebar}"
    end

    object_parsed = env[:object_parsed]
    if object_parsed.is_a? String
      Kernel.puts "#{sidebar} #{object_parsed}"
    else
      object_parsed.each do |s|
        Kernel.puts "#{sidebar} #{s}"
      end
    end

    true
  end
  
  def self.sidebar_for env
    sidebar = ""

    source = env[:unit_class]

    # TODO: Figure out why RequestPanel is returning false when started from rack command but not from request command
    # source_is_a_panel = source < Panel
    # source_is_a_panel = source.ancestors.include? Panel
    # source_is_a_panel = env[:unit].is_a? Panel
    source_is_a_panel = source.to_s.end_with? "Panel"

    if source_is_a_panel
      namespace, _sep, classname = env[:unit_class].controller.name.rpartition('::')
      sidebar << "#{namespace}::" unless namespace.empty?
      sidebar << "#{classname}.panel."
    else
      method_sep = env[:instance] ? "#" : ":"

      namespace, _sep, classname = env[:unit_class].name.rpartition('::')
      sidebar << "#{namespace}::" unless namespace.empty?
      sidebar << "#{classname}#{method_sep}"
    end

    sidebar << env[:method_name]

    size = DevBox[:log].sidebar_size - sidebar.size - 1
    size = 0 if size < 0
    sidebar << " " * size

    sidebar
  end

end
