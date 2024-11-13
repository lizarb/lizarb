class DevSystem::ControllerShell < DevSystem::Shell

  #
  
  def self.places_for(controller)
    ret = {
      "app" => "#{App.relative_path}/#{controller.system.token}/#{controller.plural}",
    }

    AppShell.writable_systems.each do |system_key, system|
      path = system.source_location_radical.gsub "#{App.root}/", ""
      ret[system_key.to_s] = "#{path}/#{controller.plural}"
      system.subs.each do |sub|
        ret["#{system_key}/#{sub}"] = "#{path}/subsystems/#{sub}/#{controller.plural}"
      end
    end

    ret
  end
  
  def self.places_for_division(controller, division_name)
    ret = {
      "app" => "#{App.relative_path}/#{controller.system.token}/#{division_name}_#{controller.plural}",
    }

    AppShell.writable_systems.each do |system_key, system|
      path = system.source_location_radical.gsub "#{App.root}/", ""
      ret[system_key.to_s] = "#{path}/#{division_name}_#{controller.plural}"
      system.subs.each do |sub|
        ret["#{system_key}/#{sub}"] = "#{path}/subsystems/#{sub}/#{division_name}_#{controller.plural}"
      end
    end

    ret
  end

  def self.places_for_systems(controller_name)
    ret = {}

    AppShell.writable_systems.each do |system_key, system|
      path = system.source_location_radical.gsub "#{App.root}/", ""
      ret[system_key.to_s] = "#{path}/subsystems/#{controller_name}"
    end

    ret
  end

  def self.path_for(place, name)
    system_name, subsystem_name = place.split("/")
    if system_name == "app"
      App.directory / "A"
    elsif subsystem_name
      App.systems_directory / "B"
    else
      App.systems_directory / "#{system_name}_system" / "subsystems" / name
    end
  end

  def self.place_for(controller)
    path = controller.source_location_path
    system = controller.system
    if path.include? App.directory.to_s
      path = path.sub(App.directory.to_s, '')
      segments = path.split('/')
      # ["", "dev", "commands", "color_command.rb"]
      # :app
      token = segments[3].split("_").last.sub(".rb", "")
      "app/#{segments[1]}/#{token}"
    elsif path.include? system.source_location_radical
      path = path.sub(system.source_location_radical, '')
      segments = path.split('/')
      # 3 ["", "commands", "test_command"]
      # 4 ["", "subsystems", "bench", "bench.rb"]
      # 5 ["", "subsystems", "bench", "commands", "bench_command.rb"]
      case segments.count
      when 3
        "#{system.token}"
      when 4, 5
        token = segments[2]
        "#{system.token}/#{token}"
      else
        raise "unexpected path: #{path} with #{segments.count} segments"
      end
    else
      segments = path.split('/')
      "other #{segments}"
    end
  end

  def self.unit_for(controller)
    place = place_for(controller)
    segments = place.split('/')
    case segments.count
    when 1
      Liza.const "#{segments[0]}_system"
    when 2, 3
      Liza.const segments.last
    else
      raise "unexpected place: #{place}"
    end
  end

end
