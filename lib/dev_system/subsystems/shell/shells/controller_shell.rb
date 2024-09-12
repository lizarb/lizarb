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

end
