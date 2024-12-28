# ShellClocCommand is a custom LinesOfCode script using gem coderay

class DevSystem::ShellLocCommand < DevSystem::SimpleCommand
  
  # liza shell_loc

  def call_default
    log "LINES OF CODE"
    puts
    log "TODO: write filters"
    puts

    print_top_level
    print_liza
    print_systems
    print_app
  end

  # sub-methods
  
  def print_top_level
    start_total
    h1 "TOP LEVEL CONSTANTS OWNED BY LIZA"
    h5 "lib/"
    AppShell.consts[:top_level].each { print_class _1 }
    print_total
    puts
  end

  def print_liza
    start_total
    h1 "LIZA NAMESPACE"
    h4 Liza
    AppShell.consts[:liza].each do |category, klasses|
      start_subtotal
      h5 "lib/liza/#{category}/"
      klasses.each { print_class _1 }
      print_subtotal
    end
    print_total
    puts
  end

  def print_systems
    h1 "SYSTEMS"
    AppShell.consts[:systems].each do |system_name, tree_system|
      start_total
      start_subtotal
      system = tree_system["system"][0]

      h4 system
      h5 "lib/#{system_name}_system/", color: system.color

      tree_system["system"].each { print_class _1 }
      tree_system["box"].each { print_class _1 }

      if tree_system["parts"].any?
        puts
        h5 "lib/#{system_name}_system/parts/", color: system.color
        tree_system["parts"].each { print_class _1 }
        puts
      end

      print_subtotal

      if tree_system["controllers"].any?
        start_subtotal
        h3 "controllers"
        tree_system["controllers"].each do |family, klasses|
          h5 "lib/#{system_name}_system/#{family.plural}/", color: system.color
          klasses.each { print_class _1 }
        end
        print_subtotal
      end

      h3 "subsystems" if tree_system["subsystems"].any?
      print_system_sub system, system_name, tree_system

      print_total
    end
    puts
  end

  def print_system_sub system, system_name, tree_system
    tree_system["subsystems"].each do |subsystem, tree_subsystem|
      h4 subsystem
      h5 "lib/#{system_name}_system/subsystems/#{subsystem.singular}/", color: system.color

      tree_subsystem["panel"].each { print_class _1 }
      tree_subsystem["controller"].each { print_class _1 }

      if tree_subsystem["parts"].any?
        puts
        h5 "lib/#{system_name}_system/subsystems/#{subsystem.singular}/parts/", color: system.color
        tree_subsystem["parts"].each { print_class _1 }
        puts
      end

      tree_subsystem["controllers"].each do |controller_class, klasses|
        start_subtotal
        h5 "lib/#{system_name}_system/subsystems/#{subsystem.singular}/#{controller_class.plural}/", color: system.color
        klasses.each { print_class _1 }
        print_subtotal
      end
    end
  end

  def print_app
    if App.global?
      h1 "TOP LEVEL CONSTANTS"
    else
      h1 "TOP LEVEL CONSTANTS OWNED BY THE TEAM"
    end
    start_total
    AppShell.consts[:app].each do |system_name, tree_system|

      system = Liza.const "#{system_name}_system"
      h5 "app/#{system_name}_box.rb", color: system.color

      tree_system["box"].each { print_class _1 }

      tree_system["controllers"].each do |family, structure|
        start_subtotal
        structure.each do |division, klasses|
          h5 "app/#{system_name}/#{division.plural}/", color: system.color
          klasses.each { print_class _1 }
        end
        print_subtotal
      end
    end
    print_total
  end

  # typography helpers

  def h1 text
    puts stick " #{ text } ".center(80, "="), :b
  end

  def h2 text, color: :white
    puts stick " #{ text } ".center(80, "-"), :b, color
  end

  def h3 text, color: :white
    puts
    puts stick " #{ text } ".center(80, " "), :b, color
  end

  def h4 system
    puts
    s = system.to_s
    s1 = s
    s1 = "#{ color(system) }" if system < Liza::Unit
    color = system.color rescue :white
    t = s.rjust(80, " ")
    t = "#{ stick t, :b, color }"
    t = t.gsub(s, s1)
    puts t
  end

  def h5 text, color: :white
    puts
    puts stick text.ljust(80, " "), color
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

  # total helpers

  def start_total
    @total_loc = 0
  end

  def start_subtotal
    @subtotal_loc = 0
  end

  def print_subtotal
    puts stick :b, :silver, "#{@subtotal_loc.to_s.rjust 5} TOTAL-ISH"
    puts
    start_subtotal
  end

  def print_total
    puts stick :b, :silver, "#{@total_loc.to_s.rjust 5} TOTAL"
  end

  # class helpers

  def print_class klass
    _text, loc = read_loc klass
    
    @total_loc += loc
    @subtotal_loc += loc if defined? @subtotal_loc

    puts "#{loc.to_s.rjust 5} LINES #{ (color klass) rescue klass }"
  end

  # loc helpers
  
  def read_loc(klass)
    fname = klass.source_location[0]
    fname = fname.sub "/version", "" if klass == Lizarb # this is a hack :)
    text  = TextShell.read(fname, log_level: :higher)
    loc   = CoderayGemShell.loc(text, :ruby)

    [text, loc]
  end

end
