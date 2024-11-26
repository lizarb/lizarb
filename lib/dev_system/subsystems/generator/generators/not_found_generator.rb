class DevSystem::NotFoundGenerator < DevSystem::SimpleGenerator

  #

  def before
    super
    env[:generator_action] = "default"
  end

  def call_default
    h3 "Liza is a light application framework written in Ruby 3.3 ❤", color: DevSystem.color
    h5 "We're optimizing for happiness. Come join us!", color: ColorShell.colors.keys.sample
    puts

    if App.global?
      print_global
    else
      print_systems
      print_app
    end
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

  # print helpers

  def print_class klass, description: nil
    sidebar_length = 50
    klass.get_generator_signatures.each do |signature|
      signature[:name] =
        signature[:name].empty? \
          ? klass.token.to_s
          : "#{klass.token}:#{signature[:name]}"
      #
    end.sort_by { _1[:name] }.map do |signature|
      next if signature[:name].end_with? ":simple"
      next if signature[:name].end_with? "!"
      puts [
        "liza generate #{signature[:name]}".ljust(sidebar_length),
        (description or signature[:description])
      ].join ""
    end
  end
  
  #

  def print_systems
    h1 "SYSTEMS"
    AppShell.consts[:systems].each do |system_name, tree_system|
      system = tree_system["system"][0]

      h4 system
      tree_system["controllers"].each do |family, klasses|
        klasses = tree_system["controllers"][family].to_a.select { _1 < Generator }
        next if klasses.empty?

        h5 "lib/#{system_name}_system/#{family.plural}/", color: system.color
        klasses.each { print_class _1 }
      end

      print_system_sub system, system_name, tree_system
    end
    puts
  end

  def print_system_sub system, system_name, tree_system
    tree_system["subsystems"].each do |subsystem, tree_subsystem|
      klasses = tree_subsystem["controllers"].values.flatten.select { _1 < Generator }
      next if klasses.empty?

      tree_subsystem["controllers"].each do |controller_class, klasses|
        klasses = klasses.select { _1 < Generator }
        klasses = klasses.reject { _1 == NewGenerator }
        klasses = klasses.reject { _1 == NotFoundGenerator }
        klasses = klasses.reject { _1 == InstallGenerator }
        klasses = klasses.reject { _1 == MoveGenerator }
        klasses = klasses.reject { _1 == OverwriteGenerator }
        klasses = klasses.reject { _1 == RemoveGenerator }
        klasses = klasses.reject { _1 == UninstallGenerator }
        next if klasses.empty?

        h5 "lib/#{system_name}_system/subsystems/#{subsystem.singular}/#{controller_class.plural}/", color: system.color
        klasses.each { print_class _1 }
      end
    end
  end

  def print_app
    h1 "TEAM CODE AT app/"

    system_name = "dev"
    tree_system = AppShell.consts[:app]["dev"]

    system = Liza.const "#{system_name}_system"
    tree_system["controllers"].each do |family, structure|
      structure.each do |division, klasses|
        klasses = klasses.select { _1 < Generator }
        if klasses.any?
          h5 "app/#{system_name}/#{division.plural}/", color: system.color
          klasses.each { print_class _1 }
        end
      end
    end
  end

  def print_global
    klasses = {
      # GemfileGenerator => "# no description",
      # EnvGenerator => "# no description",
    }

    klasses.each { print_class _1, description: _2 }

    5.times { puts }
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
    puts
  end

end
