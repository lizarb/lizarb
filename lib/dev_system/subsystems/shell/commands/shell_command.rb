class DevSystem::ShellCommand < DevSystem::SimpleCommand

  shortcut :c, :convert
  shortcut :e, :eval
  shortcut :f, :format
  shortcut :p, :paths
  shortcut :l, :loc

  section :filters

  def before
    super
    @t = Time.now
    log "simple_args     #{ simple_args }"
    log "simple_booleans #{ simple_booleans }"
    log "simple_strings  #{ simple_strings }"
  end
  
  def after
    super
    log "#{ time_diff @t }s | done"
  end

  section :actions

  # liza shell
  def call_default
    puts
    puts "Lizarb                #{ Lizarb.source_location[0] }"
    puts "Liza                  #{ Liza.source_location[0] }"
    puts "App                   #{ App.source_location[0] }"
    puts
    puts "App.type              #{ App.type.inspect }"
    puts "App.root              #{ App.root }/"
    puts "App.file              #{ App.file }"
    puts "App.directory         #{ App.directory }/"
    puts "App.systems_directory #{ App.systems_directory }/"
    puts

    largest_system_name = AppShell.consts[:systems].keys.map(&:to_s).map(&:size).max
    AppShell.consts[:systems].each do |system_name, tree_system|
      system = tree_system["system"][0]
      length = largest_system_name + 15

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

  # liza shell:convert
  def call_convert
    DevBox.command ["shell_convert", *args]
  end

  # liza shell:eval
  def call_eval
    s = args.join(' ')
    log :low, (stick system.color, "evaluating:")
    log :lower, s.inspect
    ret = eval s
    log :low, (stick system.color, "returned:")
    log :lower, ret.inspect
  end

  # liza shell:format
  def call_format
    DevBox.command ["shell_format", *args]
  end

  # liza shell:paths
  def call_paths
    puts

    set_input_array :paths do
      title = "Which paths are we going to show?"
      choices = %w[load_paths loaded_features].map { ["$#{_1.upcase}", _1] }.to_h
      answers = InputShell.multi_select title, choices, selected: :all
    end

    paths = simple_array(:paths)

    if paths.include? "load_paths"
      puts "$LOAD_PATH"
      $LOAD_PATH.each do |path|
        puts path
      end
      puts
    end

    if paths.include? "loaded_features"
      puts "$LOADED_FEATURES"
      $LOADED_FEATURES.each do |path|
        puts path
      end
      puts
    end
  end

  # liza shell:loc
  def call_loc
    DevBox.command ["shell_loc"]
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
