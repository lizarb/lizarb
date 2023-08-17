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
    case
    when source < Liza::Panel
      key = env[:unit].key
      source = source.box

      sidebar << env[:unit].box.to_s.bold.colorize(source_color)

      sidebar << "[:#{key}]."

    when source < Liza::UnitTest
      source_color = source.subject_class.log_color
      sidebar << env[:unit_class].to_s.bold.colorize(color: :white, background: :"light_#{source_color}")
    else
      method_sep = env[:instance] ? "#" : ":"
      sidebar << env[:unit_class].to_s.bold.colorize(source_color)
      sidebar << method_sep
    end

    sidebar << env[:method_name]

    sidebar.ljust(SIDEBAR_LENGTH)
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
