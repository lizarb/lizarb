class DevSystem::AppShell < DevSystem::Shell

  #
  
  def self.writable_systems
    root = App.root.to_s
    App.systems.select { _2.source_location_radical.start_with? root }
  end

  #

  def self.consts
    @instance ||= new
    @instance.consts
  end

  section :instance

  attr_reader :consts

  def initialize
    Lizarb.eager_load!
    h = @consts = {}
    h[:top_level]  = [Lizarb, App, Liza]
    h[:liza]       = get_liza_classes_structured
    h[:systems]    = get_system_classes_structured
    h[:app]        = get_object_classes_structured
  end

  #

  def get_liza_categories
    ["unit", "helper_units", "systemic_units", "subsystemic_units", "ruby_tests"]
  end

  #

  def get_liza_classes_structured
    ret = {}
    liza_classes = BootShell.liza_classes

    ret["unit"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/unit" }
        .sort_by { _1.to_s }

    ret["helper_units"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/helper_units" }
        .sort_by { _1.to_s }

    ret["systemic_units"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/systemic_units" }
        .sort_by { _1.to_s }

    ret["subsystemic_units"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/subsystemic_units" }
        .sort_by { _1.to_s }

    ret["ruby_tests"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/ruby_tests" }
        .sort_by { _1.to_s }

    raise "not all categories are filled" if get_liza_categories != ret.select { _2.any? }.keys

    ret
  end

  def get_system_classes_structured
    ret = {}
    system_classes = BootShell.system_classes

    App.systems.each do |system_name, system|
      tree = ret[system_name.to_s] = {}

      array = system_classes.select { _1.system == system }

      part_classes = array.select { _1.source_location_radical.include? "/#{system_name}_system/parts/" }

      tree["system"]      = [system, system.test_class]
      tree["box"]         = [system.box, system.box.test_class]
      tree["parts"]       = part_classes
      tree["controllers"] = {}
      tree["subsystems"]  = {}

      array.delete system
      array.delete system.test_class
      array.delete system.box
      array.delete system.box.test_class
      part_classes.each do |klass|
        array.delete klass
      end

      system.subsystems.each do |subsystem|
        part_classes = array.select { _1.source_location_radical.include?("/subsystems/#{subsystem.last_namespace.downcase}/parts/") }
        tree["subsystems"][subsystem] = {}
        tree["subsystems"][subsystem]["parts"] = part_classes
        tree["subsystems"][subsystem]["panel"] = [subsystem.panel.class, subsystem.panel.class.test_class]
        tree["subsystems"][subsystem]["controller"] = [subsystem, subsystem.test_class]
        tree["subsystems"][subsystem]["controllers"] = {}

        array.delete subsystem.panel.class
        array.delete subsystem.panel.class.test_class
        array.delete subsystem
        array.delete subsystem.test_class
        part_classes.each do |klass|
          array.delete klass
        end

      end

      array.each do |klass|
        radical = klass.source_location_radical

        if radical.include? "/#{system_name}_system/subsystems"
          name = radical.split("_system/subsystems/").last.split("/").first
          subsystem = system.const name
          klasses = tree["subsystems"][subsystem]["controllers"][klass.division] ||= []
        else
          klasses = tree["controllers"][klass.division] ||= []
        end

        klasses << klass
      end

    end

    ret.each do |system_name, tree|
      tree["subsystems"].each do |subsystem_name, subsystem_tree|
        subsystem_tree["controllers"].each do |division, controllers|
          controllers.sort_by! &:to_s
        end
      end
      tree["controllers"].each do |division, controllers|
        controllers.sort_by! &:to_s
      end
    end

    ret
  end

  def get_object_classes_structured
    ret = {}
    object_classes = BootShell.object_classes.sort_by { _1.source_location_radical }

    App.systems.each do |system_name, system|
      tree = ret[system_name.to_s] = {}

      a = object_classes.select { _1.system == system }
      
      tree["box"] = []
      box = Liza.const "#{system_name}_box"
      if box.namespace == Object
        tree["box"] << box
        a.delete box
      end

      tree["controllers"] = {}

      a.each do |klass|
        tree["controllers"][klass.subsystem] ||= {}
        tree["controllers"][klass.subsystem][klass.division] ||= []
        tree["controllers"][klass.subsystem][klass.division] << klass
      end

      system.subsystems.each do |subsystem|
        tree["controllers"][subsystem]&.each do |division, klasses|
          klasses.sort_by! &:to_s
        end
      end
    end

    ret
  end

  section :sorted

  def sorted_writable_units_in_systems
    @sorted_writable_units_in_systems ||= sorted_units.select { _1.source_location_radical.start_with? App.systems_directory.to_s }
  end

  def sorted_writable_units
    @sorted_writable_units ||= sorted_units.select { _1.source_location_radical.start_with? App.root.to_s }
  end

  def sorted_units
    @sorted_units ||= begin
      ret = []
      consts[:liza].each do |category, classes|
        classes.each do |klass|
          ret << klass
        end
      end
      consts[:systems].each do |system_name, tree|
        tree["box"].each do |klass|
          ret << klass
        end
        tree["parts"].each do |klass|
          ret << klass
        end
        tree["controllers"].each do |division, controllers|
          controllers.each do |klass|
            ret << klass
          end
        end

        tree["subsystems"].each do |subsystem_name, subsystem_tree|
          subsystem_tree["panel"].each do |klass|
            ret << klass
          end
          subsystem_tree["parts"].each do |klass|
            ret << klass
          end
          subsystem_tree["controller"].each do |klass|
            ret << klass
          end
          subsystem_tree["controllers"].each do |division, controllers|
            controllers.each do |klass|
              ret << klass
            end
          end
        end
      end
      consts[:app].each do |system_name, tree|
        tree["box"].each do |klass|
          ret << klass
        end
        tree["controllers"].each do |subsystem, divisions|
          divisions.each do |division, controllers|
            controllers.each do |klass|
              ret << klass
            end
          end
        end
      end
      ret.freeze
    end
  end

  section :lists

  def lists
    @lists ||= get_lists
  end

  def get_units
    lists.flatten.select { _1 <= Liza::Unit }
  end

  def get_test_units
    units.select { _1 <= Liza::UnitTest }
  end

  def get_lists
    ret = []

    ret << consts[:top_level]

    consts[:liza].each do |category, classes|
      ret << classes
    end

    consts[:systems].each do |system_name, tree_system|
      ret << tree_system["system"]
      ret << tree_system["box"]
      ret << tree_system["parts"]
      tree_system["controllers"].each do |family, klasses|
        ret << klasses
      end
      tree_system["subsystems"].each do |subsystem, tree_subsystem|
        ret << tree_subsystem["panel"]
        ret << tree_subsystem["controller"]
        tree_subsystem["controllers"].each do |controller_class, klasses|
          ret << klasses
        end
      end
    end

    consts[:app].each do |system_name, tree_system|
      ret << tree_system["box"]
      tree_system["controllers"].each do |family, structure|
        structure.each do |division, klasses|
          ret << klasses
        end
      end
    end

    ret
  end

  section :filters

  def filter_out_units(*units)
    log_filter units.inspect
    check

    lists.each do |list|
      list.reject! { units.include? _1 }
    end

    self
  end

  def filter_by_unit(unit_class)
    log_filter unit_class.inspect
    check

    lists.each do |list|
      list.reject! { _1.class == Module }
      list.select! { _1 <= unit_class }
    end

    self
  end

  def filter_by_systems(*systems)
    log_filter systems.inspect
    systems = systems.map { (_1.is_a? Symbol) ? App.systems[_1] : _1 }
    check

    lists.each do |list|
      list.reject! { _1 <= Module }
      list.select! { _1 <= Liza::Unit }
      list.select! { systems.include? _1.system }
    end

    self
  end

  def filter_by_name_including(name)
    name = name.downcase
    log_filter name.inspect
    check

    lists.each do |list|
      list.select! { _1.to_s.snakecase.include? name }
    end

    self
  end

  def filter_by_starting_with(name)
    name = name.downcase
    log_filter name.inspect
    check

    lists.each do |list|
      list.select! { _1.to_s.snakecase.start_with? name }
    end

    self
  end

  def log_filter(string)
    log (stick :black, :light_green, string), kaller: caller if log? :higher
  end

  def filter_history
    @filter_history ||= []
  end

  def check
    filter_history << lists.map(&:dup)
    _log_history
  end

  def undo_filter!
    old_lists = filter_history.pop
    lists.each.with_index do |list, i|
      list.clear
      list.concat old_lists[i]
    end
    _log_history
  end

  def _log_history
    log_filter "filter_history size: #{filter_history.size}, results size: #{lists.map(&:size).sum}"
  end

  section :structures

  # Returns an array of structures representing the core, systems, and app.
  #
  # Each Structure contains the name, color, and layers of the core, systems, and app.
  #
  # @return [Array<Structure>] An array of structures.
  #
  # @example
  #   structures = app_shell.get_structures
  #   structures.each do |structure|
  #     log structure.name
  #     log structure.color
  #     structure.layers.each do |layer|
  #       log layer.name
  #       log layer.path
  #       layer.objects.each do |object|
  #         log object
  #       end
  #     end
  #   end
  #
  def get_structures
    ret = []

    log_filter "reading the structure of the core"

    ret << Structure.new(
      name: "core",
      color: :white,
      layers: get_layers_for_core
    )

    log_filter "reading the structure of the systems"

    App.systems.values.each do |system|
      ret << Structure.new(
        name: system.to_s,
        color: system.color,
        layers: get_layers_for_system(system)
      )
    end

    log_filter "reading the structure of the app"

    ret << Structure.new(
      name: "app",
      color: :white,
      layers: get_layers_for_app
    )

    ret
  end

  def get_layers_for_core
    ret = []

    ret << Layer.new(
      level: 1,
      name: "top level",
      color: :white,
      path: "lib/",
      objects: consts[:top_level]
    )

    consts[:liza].each do |category, classes|
      path = "lib/liza/#{category}/"
      ret << Layer.new(
        level: 2,
        name: category,
        color: :white,
        path: ,
        objects: classes
      )
    end

    ret
  end

  def get_layers_for_system(system)
    ret = []

    tree_system = consts[:systems][system.token.to_s]
    path = system.source_location_radical.sub("#{App.root}/", "")
    ret << Layer.new(
      level: 1,
      name: system.to_s,
      color: system.color,
      path: ,
      objects: tree_system["system"] + tree_system["box"]
    )
    
    tree_system["controllers"].each do |division, klasses|
      path = system.source_location_radical.sub("#{App.root}/", "")
      path << "/#{division.plural}/"

      name = division.plural
      color = division.subsystem.system.color

      ret << Layer.new(
        level: 3,
        name: ,
        color: ,
        path: ,
        objects: klasses
      )
    end

    tree_system["subsystems"].each do |subsystem, tree_subsystem|
      path = system.source_location_radical.sub("#{App.root}/", "")
      path << "/subsystems/#{subsystem.singular}/"
      ret << Layer.new(
        level: 2,
        name: subsystem.to_s,
        color: system.color,
        path: ,
        objects: tree_subsystem["controller"] + tree_subsystem["panel"]
      )

      tree_subsystem["controllers"].each do |controller_class, klasses|
        path = system.source_location_radical.sub("#{App.root}/", "")
        path << "/subsystems/#{subsystem.singular}/#{controller_class.division.plural}/"

        name = controller_class.plural
        color = controller_class.subsystem.system.color

        ret << Layer.new(
          level: 3,
          name: ,
          color: ,
          path: ,
          objects: klasses
        )
      end
    end

    ret
  end

  def get_layers_for_app
    ret = []

    ret << Layer.new(
      level: 1,
      name: "App",
      color: system.color,
      path: "#{App.directory_name}/",
      objects: consts[:top_level].select { _1.name == "App" }
    )

    consts[:app].each do |system_name, tree_system|
      system = App.systems[system_name.to_sym]
      ret << Layer.new(
        level: 2,
        name: system_name,
        color: system.color,
        path: "app/#{system_name}_box.rb",
        objects: tree_system["box"]
      )
      tree_system["controllers"].each do |family, structure|
        structure.each do |division, klasses|
          ret << Layer.new(
            level: 3,
            name: division.plural,
            color: system.color,
            path: "app/#{system_name}/#{division.plural}/",
            objects: klasses
          )
        end
      end
    end

    ret
  end

  # A PORO representing a top-level namespace of LizaRB.
  class Structure
    def initialize(name: , color: , layers: )
      @name = name
      @color = color
      @layers = layers
    end

    attr_reader :name, :color, :layers

    def empty?
      layers.map(&:objects).flatten.empty?
    end
  end

  # A PORO representing a layer in a namespace of LizaRB.
  class Layer
    def initialize(level: , name: , color: , path: , objects: )
      @level = level
      @name = name
      @color = color
      @path = path
      @objects = objects
    end

    attr_reader :level, :name, :color, :path, :objects
  end

end
