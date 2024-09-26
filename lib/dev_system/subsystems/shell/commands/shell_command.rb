class DevSystem::ShellCommand < DevSystem::SimpleCommand

  # liza shell
  def call_default
    puts
    puts "Lizarb       #{ Lizarb.source_location[0] }"
    puts "Liza         #{ Liza.source_location[0] }"
    puts "App          #{ App.source_location[0] }"
    puts
    puts "App.type     #{ App.type.inspect }"
    puts
    puts "App.folder   #{ App.folder || "nil" }"
    puts "App.root     #{ App.root }/"
    puts "App.path     #{ App.path ? "#{App.path}/" : "nil" }"
    puts "App.sys_path #{App.sys_path}/"
    puts

    largest_system_name = AppShell.consts[:systems].keys.map(&:to_s).map(&:size).max
    AppShell.consts[:systems].each do |system_name, tree_system|
      system = tree_system["system"][0]
      length = largest_system_name + 14

      puts "#{
        "#{system.token == :dev ? "App.system" : "          "}   #{system.token.inspect}"
          .ljust(length)
          .sub(system.token.inspect, (stick system.token.inspect, system.color).to_s)
      } #{
        system.source_location[0]
      }"
    end

    puts
  end

  # liza shell:load_path
  def call_load_path
    puts

    puts "$LOAD_PATH"
    $LOAD_PATH.each do |path|
      puts path
    end
    puts
  end

  # liza shell:cloc
  def call_cloc
    DevBox.command ["loc"]
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
