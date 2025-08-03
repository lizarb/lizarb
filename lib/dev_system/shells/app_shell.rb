class DevSystem::AppShell < DevSystem::Shell

  #
  
  def self.writable_systems
    root = App.root.to_s
    App.systems.select { _2.source_location_radical.start_with? root }
  end

  def self.get_writable_domains
    ret = {}
    is_core_writeable = Lizarb.is_gem_dir

    ret[:core] = "Core" if is_core_writeable
    ret.merge! writable_systems
    ret[:app] = "App"
    ret.transform_keys! { _1.to_s }

    ret
  end

  # Returns an array of units in the specified class.
  #
  # @param klass [Class] The class to filter by.
  # @param log_level [Symbol] The log level for logging.
  #
  # @return [Array<Class>] An array of units in the specified class.
  #
  # @example
  #   units = AppShell.units(MyClass, log_level: :low)
  #   units.each do |unit|
  #     log unit
  #   end
  #
  # @see AppShell.units_in_domain
  # @see AppShell.controllers
  # @see AppShell.controllers_in_domain
  def self.units(klass, log_level: self.log_level)
    i = new
    i.filter_by_unit klass
    i.get_domains.map { _1.layers.map(&:objects) }.flatten
  end

  # Returns all units in the specified domain.
  #
  # @param klass [Class] The class to filter by.
  # @param domain [String] The domain to filter by.
  # @param log_level [Symbol] The log level for logging.
  #
  # @return [Array<Class>] An array of units in the specified domain.
  #
  # @example
  #   units = AppShell.units_in_domain(MyClass, "app", log_level: :low)
  #   units.each do |unit|
  #     log unit
  #   end
  #
  # @see AppShell.units
  def self.units_in_domain(klass, domain, log_level: self.log_level)
    i = new
    i.filter_by_unit klass
    i.filter_by_domains [domain], log_level: log_level
    i.get_domains.map { _1.layers.map(&:objects) }.flatten
  end

  # Returns an array of controllers in the specified domain.
  #
  # @param klass [Class] The class to filter by.
  # @param log_level [Symbol] The log level for logging.
  #
  # @return [Array<Class>] An array of controllers in the specified domain.
  #
  # @example
  #   controllers = AppShell.controllers(MyClass, log_level:
  #   controllers.each do |controller|
  #     log controller
  #   end
  #
  # @see AppShell.units
  def self.controllers(klass, log_level: self.log_level)
    units(klass, log_level:)
  end

  # Returns all controllers in the specified domain.
  #
  # @param klass [Class] The class to filter by.
  # @param domain [String] The domain to filter by.
  # @param log_level [Symbol] The log level for logging.
  #
  # @return [Array<Class>] An array of controllers in the specified domain.
  #
  # @example
  #   controllers = AppShell.controllers_in_domain(MyClass, "app", log_level: :low)
  #   controllers.each do |controller|
  #     log controller
  #   end
  #
  # @see AppShell.units
  def self.controllers_in_domain(klass, domain, log_level: self.log_level)
    units_in_domain(klass, domain, log_level:)
  end



  #

  def self.consts
    new.consts
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

  def _log_count(log_level, msg)
    log log_level, "count: #{count} | #{msg}"
  end

  def count() = get_lists.flatten.count

  #

  def get_liza_categories
    ["unit", "helper_units", "systemic_units", "subsystemic_units", "extra_tests"]
  end

  #

  def get_liza_classes_structured
    ret = {}
    liza_classes = ZeitwerkShell.get_units_in_core

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

    ret["extra_tests"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/extra_tests" }
        .sort_by { _1.to_s }

    ret
  end

  def get_system_classes_structured
    ret = {}

    App.systems.each do |system_name, system|
      tree = ret[system_name.to_s] = {}

      system_classes = ZeitwerkShell.get_units_in_system system
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

      system.subsystems.values.each do |subsystem|
        part_classes = array.select { _1.source_location_radical.include?("/subsystems/#{subsystem.last_namespace.downcase}/parts/") }
        tree["subsystems"][subsystem.singular] = {}
        tree["subsystems"][subsystem.singular]["parts"] = part_classes
        tree["subsystems"][subsystem.singular]["panel"] = [subsystem.panel.class, subsystem.panel.class.test_class]
        tree["subsystems"][subsystem.singular]["controller"] = [subsystem, subsystem.test_class]
        tree["subsystems"][subsystem.singular]["controllers"] = {}

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
        tree = ret[system_name.to_s] or raise "no tree for #{system_name}"

        if radical.include? "/#{system_name}_system/subsystems"
          name = radical.split("_system/subsystems/").last.split("/").first
          subsystem = system.const name
          klasses = tree["subsystems"][subsystem.singular]["controllers"][klass.division.last_namespace] ||= []
        else
          klasses = tree["controllers"][klass.division.last_namespace] ||= []
        end

        klasses << klass
      end

    end

    ret.each do |system_name, tree|
      tree["subsystems"].each do |subsystem_name, subsystem_tree|
        subsystem_tree["controllers"].values.each do |controllers|
          controllers.sort_by! &:to_s
        end
      end
      tree["controllers"].values.each do |controllers|
        controllers.sort_by! &:to_s
      end
    end

    ret
  end

  def get_object_classes_structured
    ret = {}

    object_classes = ZeitwerkShell.get_units_in_app.sort_by { _1.source_location_radical }

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
        tree["controllers"][klass.subsystem.singular] ||= {}
        tree["controllers"][klass.subsystem.singular][klass.division.last_namespace] ||= []
        tree["controllers"][klass.subsystem.singular][klass.division.last_namespace] << klass
      end

      system.subsystems.values.each do |subsystem|
        tree["controllers"][subsystem.singular]&.each do |division, klasses|
          klasses.sort_by! &:to_s
        end
      end

    end

    ret
  end

  section :sorted

  def sorted_writable_units_in_systems
    sorted_units.select { _1.source_location_radical.start_with? App.systems_directory.to_s }
  end

  def sorted_writable_units
    sorted_units.select { _1.source_location_radical.start_with? App.root.to_s }
  end

  def sorted_units
    begin
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
        tree["controllers"].values.each do |controllers|
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
          subsystem_tree["controllers"].values.each do |controllers|
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
        tree["controllers"].values.each do |divisions|
          divisions.values.each do |controllers|
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

  def get_units
    get_lists.flatten.select { _1 <= Liza::Unit }
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
      tree_system["controllers"].values.each do |klasses|
        ret << klasses
      end
      tree_system["subsystems"].values.each do |tree_subsystem|
        ret << tree_subsystem["panel"]
        ret << tree_subsystem["controller"]
        tree_subsystem["controllers"].values.each do |klasses|
          ret << klasses
        end
      end
    end

    consts[:app].each do |system_name, tree_system|
      ret << tree_system["box"]
      tree_system["controllers"].each do |_controller, structure|
        
        structure.each do |_division, klasses|
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

    get_lists.each do |list|
      list.reject! { units.include? _1 }
    end

    self
  end

  def filter_in_units(*units)
    log_filter units.inspect
    check

    get_lists.each do |list|
      list.select! { units.include? _1 }
    end

    self
  end

  def filter_by_unit(unit_class)
    log_filter unit_class.inspect
    check

    get_lists.each do |list|
      list.reject! { _1.class == Module }
      list.select! { _1 <= unit_class }
    end

    self
  end

  def filter_by_domains(domains, log_level: self.log_level)
    log_filter domains.inspect
    check
    _log_count log_level, ""

    system_names = domains - ["core", "app"]
    is_core_included = domains.include? "core"
    is_app_included = domains.include? "app"

    unless is_core_included
      _log_count log_level, "core is not included in the domains"

      consts[:top_level].clear
      consts[:liza].values.map &:clear
    end

    consts[:systems].reject do |system_name, tree_system|
      system_names.include? system_name
    end.each do |system_name, tree_system|
      tree_system["system"].clear
      tree_system["box"].clear
      tree_system["parts"].clear
        tree_system["controllers"].values.map &:clear
        tree_system["subsystems"].values.map { _1.values.map &:clear }

      _log_count log_level, "#{system_name} is not included in the domains"
    end

    unless is_app_included
      consts[:app].each do |system_name, tree_system|
        tree_system["box"].clear
        tree_system["controllers"].values.each { _1.values.map &:clear }
      end
      
      _log_count log_level, "app is not included in the domains"
    end

    _log_count log_level, ""

    self
  end

  def filter_by_systems(*systems)
    log_filter systems.inspect
    systems = systems.map { (_1.is_a? Symbol) ? App.systems[_1] : _1 }
    check

    get_lists.each do |list|
      list.select! { (_1 <= Liza::Unit) ? (systems.include? _1.system) : true }
    end

    self
  end

  def filter_by_name_including(name)
    name = name.downcase
    log_filter name.inspect
    check

    get_lists.each do |list|
      list.select! { _1.to_s.snakecase.include? name }
    end

    self
  end

  def filter_by_starting_with(name)
    name = name.downcase
    log_filter name.inspect
    check

    get_lists.each do |list|
      list.select! { _1.last_namespace.snakecase.start_with? name }
    end

    self
  end

  def filter_by_any_name_including(names)
    names = names.map &:snakecase
    log_filter names.inspect
    check

    get_lists.each do |list|
      list.select! { |klass| names.any? { |name| klass.last_namespace.snakecase.include? name } }
    end

    self
  end

  def filter_by_including_all_names(names)
    names = names.map &:snakecase
    log_filter names.inspect
    check

    get_lists.each do |list|
      list.select! { |klass| names.all? { |name| klass.last_namespace.snakecase.include? name } }
    end

    self
  end

  def filter_by_including_any_name(names)
    filter_by_any_name_including(names)
  end

  def log_filter(string)
    log (stick :black, :light_green, string), kaller: caller if log? :higher
  end

  def filter_history
    @filter_history ||= []
  end

  def check
    filter_history << get_lists.map(&:dup)
    _log_history
  end

  def undo_filter!
    old_lists = filter_history.pop
    get_lists.each.with_index do |list, i|
      list.clear
      list.concat old_lists[i]
    end
    _log_history
  end

  def _log_history
    log_filter "filter_history size: #{filter_history.size}, results size: #{get_lists.map(&:size).sum}"
  end

  section :domains

  # Returns an array of domains representing the core, systems, and app.
  #
  # Each Domain contains the name, color, and layers of the core, systems, and app.
  #
  # @return [Array<Domain>] An array of domains.
  #
  # @example
  #   domains = app_shell.get_domains
  #   domains.each do |domain|
  #     log domain.name
  #     log domain.color
  #     domain.layers.each do |layer|
  #       log layer.name
  #       log layer.path
  #       layer.objects.each do |object|
  #         log object
  #       end
  #     end
  #   end
  #
  def get_domains
    ret = []

    log_filter "reading the domain of the core"

    ret << Domain.new(
      name: "core",
      color: :white,
      layers: get_layers_for_core
    )

    log_filter "reading the domains of the systems"

    App.systems.values.each do |system|
      log_filter "-- reading the domain of the system #{system}"
      ret << Domain.new(
        name: system.to_s,
        color: system.color,
        layers: get_layers_for_system(system)
      )
    end

    log_filter "reading the domain of the app"

    ret << Domain.new(
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
        level: (category=="unit" || category=="extra_tests" ? 2 : 3),
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
    
    tree_system["controllers"].each do |division_name, klasses|
      division = Liza.const division_name
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

    tree_system["subsystems"].each do |subsystem_token, tree_subsystem|
      subsystem = system.const subsystem_token
      path = system.source_location_radical.sub("#{App.root}/", "")
      path << "/subsystems/#{subsystem.singular}/"
      ret << Layer.new(
        level: 2,
        name: subsystem.to_s,
        color: system.color,
        path: ,
        objects: tree_subsystem["controller"] + tree_subsystem["panel"]
      )

      tree_subsystem["controllers"].each do |controller_name, klasses|
        controller = Liza.const controller_name
        path = system.source_location_radical.sub("#{App.root}/", "")
        path << "/subsystems/#{subsystem.singular}/#{controller.division.plural}/"

        name = controller.plural
        color = controller.subsystem.system.color

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
      color: :white,
      path: "#{App.directory_name}/",
      objects: []
    )

    consts[:app].each do |system_name, tree_system|
      system = App.systems[system_name.to_sym]
      ret << Layer.new(
        level: 2,
        name: system_name,
        color: :white,
        path: "app/#{system_name}_box.rb",
        objects: tree_system["box"]
      )
      tree_system["controllers"].each do |controller_name, structure|
        structure.each do |division_name, klasses|
          division = Liza.const division_name
          ret << Layer.new(
            level: 3,
            name: division.plural,
            color: :white,
            path: "app/#{system_name}/#{division.plural}/",
            objects: klasses
          )
        end
      end
    end

    ret
  end

  def get_structured_domains
    ret = {}

    get_domains.each do |domain|
      ret[domain.name] = domain.get_structured_layers
    end

    ret
  end

  # A PORO representing a top-level namespace of LizaRB.
  class Domain
    def initialize(name: , color: , layers: )
      @name = name
      @color = color
      @layers = layers
    end

    attr_reader :name, :color, :layers

    def empty?
      layers.map(&:objects).flatten.empty?
    end

    def get_structured_layers
      ret = {}
      last = nil
      layers.each do |layer|
        if layer.name.is_a?(String)
          ret[layer.name] = {layer: layer, controllers: {}}
          last = layer
        else
          ret[last.name][:controllers][layer.name] = layer
        end
      end
      ret
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
