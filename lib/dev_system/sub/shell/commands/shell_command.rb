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

end
