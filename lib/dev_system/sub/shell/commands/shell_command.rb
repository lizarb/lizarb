class DevSystem::ShellCommand < DevSystem::Command

  def call args
    puts
    puts "Liza         #{ Liza.source_location[0] }"
    puts "App.folder   #{ App.folder }"
    puts "App.root     #{ App.root }/"
    puts "App.path     #{ App.path }/"
    puts

    largest_system_name = AppShell.consts[:systems].keys.map(&:to_s).map(&:size).max

    AppShell.consts[:systems].each do |system_name, tree_system|
      system = tree_system["system"][0]
      length = largest_system_name + 6

      puts "#{ 
        "#{system.to_s}"
          .ljust(length)
          .sub(system.to_s, color(system).to_s)
       } #{ system.source_location[0] }"
    end

    puts
  end

  # color helpers

  def color klass
    return klass unless klass < Liza::Unit

    namespace, _sep, classname = klass.to_s.rpartition('::')

    if namespace.empty?
      return stick classname, Liza.const(classname).system.color
    end

    "#{
      stick namespace, Liza.const(namespace).system.color
    }::#{
      stick classname, Liza.const(classname).color
    }"
  end

  # liza shell:format FORMAT FILENAME

  def self.format args
    log :lower, "args = #{args.inspect}"

    raise ArgumentError, "args[0] must be present" unless args[0]

    format = args[0].to_sym
    raise ArgumentError, "formatter #{format.inspect} not found" unless DevBox.format? format

    fname = args[1]
    raise ArgumentError, "fname must be present" unless FileShell.file? fname

    content = TextShell.read fname

    fname = "#{fname}.#{format}"
    content = DevBox.format format, content

    TextShell.write fname, content
  end

  # liza shell:convert FORMAT FILENAME

  def self.convert args
    log :lower, "args = #{args.inspect}"

    raise ArgumentError, "args[0] must be present" unless args[0]

    format = args[0].to_sym
    raise ArgumentError, "converter #{format.inspect} not found" unless DevBox.convert? format

    fname = args[1]
    raise ArgumentError, "fname must be present" unless FileShell.file? fname

    content = TextShell.read fname

    to_format = DevBox.converters[format][:to]
    fname = "#{fname}.#{to_format}"
    content = DevBox.convert format, content

    TextShell.write fname, content
  end

end
