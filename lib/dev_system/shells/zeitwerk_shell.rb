class DevSystem::ZeitwerkShell < DevSystem::Shell

  def self.get_units_in_core
    get_core_mappings.values.map(&:get)
  end

  def self.get_units_in_systems
    ret = {}

    App.systems.each do |key, system|
      ret[key] = get_units_in_system(system)
    end
    
    ret
  end

  def self.get_units_in_system(system)
    s = system.source_location_radical
    ret = get_main_mappings
    ret = ret.select { _1.start_with? s }
    ret.values.map(&:get)
  end

  def self.get_units_in_app
    s = App.directory.to_s
    ret = get_main_mappings
    ret = ret.select { _1.start_with? s }
    ret.values.map(&:get)
  end

  def self.get_core_mappings
    ret = {}

    core_loader.__autoloads.each do |path, reference|
      ret[path] = reference
    end
    core_loader.__to_unload.each do |name, (path, reference)|
      ret[path] = reference
    end

    ret
  end

  def self.get_main_mappings
    ret = {}

    main_loader.__autoloads.each do |path, reference|
      ret[path] = reference
    end
    main_loader.__to_unload.each do |name, (path, reference)|
      ret[path] = reference
    end

    ret
  end

  def self.get_unit_in_system(system, name)
    cname = name.to_s.camelcase.to_sym
    mappings = get_mappings_in_system(system)
    references = mappings.values.select { _1.cname == cname }
    references.first.get
  rescue NoMethodError
    nil
  end

  def self.get_unit_in_app(name)
    cname = name.to_s.camelcase.to_sym
    mappings = get_mappings_in_app
    references = mappings.values.select { _1.cname == cname }
    references.first.get
  rescue NoMethodError
    nil
  end


  def self.get_mappings_in_system(system)
    s = system.source_location_radical
    ret = get_main_mappings
    ret = ret.select { _1.start_with? s }
    ret
  end

  def self.get_mappings_in_app
    s = App.directory.to_s
    ret = get_main_mappings
    ret = ret.select { _1.start_with? s }
    ret
  end

  def self.core_loader() = Lizarb.loaders[0]
  
  def self.main_loader() = Lizarb.loaders[1]
  
end
