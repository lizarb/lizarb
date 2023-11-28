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

  attr_reader :consts

  def initialize
    liza_classes = self.class.liza_classes
    liza_categories = self.class.liza_categories
    h = @consts = {}
    h[:top_level]  = [Lizarb, App, Liza]
    h[:liza]       = self.class.liza_classes_structured
    h[:systems]    = self.class.system_classes_structured
    h[:app]        = self.class.object_classes_structured
  end

  #

  def self.liza_classes
    Lizarb.loaders[0].__to_unload.keys.map { Object.const_get _1 }
  end

  def self.implementation_classes
    Lizarb.loaders[1].__to_unload.keys.map { Object.const_get _1 }
  end

  #

  def self.system_classes
    implementation_classes.reject { _1.namespace == Object }
  end

  def self.object_classes
    implementation_classes.select { _1.namespace == Object }
  end

  #

  def self.liza_categories
    ["unit", "base", "safety", "meta", "ruby_tests"]
  end

  #

  def self.liza_classes_structured
    ret = {}
    liza_classes = self.liza_classes

    ret["unit"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/unit" }
        .sort_by { _1.to_s }

    ret["base"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/base" }
        .sort_by { _1.to_s }

    ret["safety"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/safety" }
        .sort_by { _1.to_s }

    ret["meta"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/meta" }
        .sort_by { _1.to_s }

    ret["ruby_tests"] =
      liza_classes
        .select { _1.source_location_radical.include? "/liza/ruby_tests" }
        .sort_by { _1.to_s }

    raise "not all categories are filled" if liza_categories != ret.select { _2.any? }.keys

    ret
  end

  def self.system_classes_structured
    ret = {}
    system_classes = self.system_classes

    App.systems.each do |system_name, system|
      tree = ret[system_name.to_s] = {}

      array = system_classes.select { _1.system == system }

      tree["system"]      = [system]
      tree["box"]         = [system.box, system.box.test_class]
      tree["controllers"] = {}
      tree["subsystems"]  = {}

      array.delete system
      array.delete system.box
      array.delete system.box.test_class
      
      system.subsystems.each do |subsystem|
        tree["subsystems"][subsystem] = {}
        tree["subsystems"][subsystem]["panel"] = [subsystem.panel.class, subsystem.panel.class.test_class]
        tree["subsystems"][subsystem]["controller"] = [subsystem, subsystem.test_class]
        tree["subsystems"][subsystem]["controllers"] = {}

        array.delete subsystem.panel.class
        array.delete subsystem.panel.class.test_class
        array.delete subsystem
        array.delete subsystem.test_class
      end

      array.each do |klass|
        radical = klass.source_location_radical

        if radical.include? "/#{system_name}_system/sub"
          name = radical.split("_system/sub/").last.split("/").first
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

  def self.object_classes_structured
    ret = {}
    object_classes = self.object_classes.sort_by { _1.source_location_radical }

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

end
