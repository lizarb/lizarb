class DevSystem::LogPanel < Liza::Panel

  # TODO: https://rubyapi.org/3.1/o/logger

  SIDEBAR_LENGTH = 60
  
  def call env
    env[:instance] ||= env[:unit_class] == env[:unit]
    env[:method_name] ||= method_name_for env
    env[:sidebar] ||= sidebar_for env

    string = env[:object].to_s

    unless $coding
      pid = Process.pid
      tid = Lizarb.thread_id.to_s.rjust_zeroes 3
      env[:sidebar] = "#{pid} #{tid} #{env[:sidebar]}"
    end

    string = "#{env[:sidebar]} #{string}"
    puts string
  end

  # NOTE: improve logs performance and readability

  def sidebar_for env
    sidebar = ""

    source = env[:unit_class]
    source_color = source.log_color
    system_color = source.system.log_color
    size = 0

    if source < Liza::Panel
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

  def method_name_for env
    env[:caller].each do |s|
      t = s.match(/`(.*)'/)[1]

      next if t.include? " in <class:"
      return t.split(" ").last if t.include? " in "

      next if t == "log"
      next if t == "each"
      next if t == "map"
      next if t == "with_index"
      next if t == "instance_exec"
      next if t.start_with? "_"
      return t
    end

    raise "there's something wrong with kaller"
  end

end
