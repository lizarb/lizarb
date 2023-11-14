class DevSystem::ControllerShell < DevSystem::Shell

  #
  
  def self.places_for(controller)
    ret = {
      "app" => "#{App.relative_path}/#{controller.system.token}/#{controller.plural}",
    }

    AppShell.writable_systems.each do |system_key, system|
      ret[system_key.to_s] = "lib/#{system_key}_system/#{controller.plural}"
      system.subs.each do |sub|
        ret["#{system_key}/#{sub}"] = "lib/#{system_key}_system/sub/#{sub}/#{controller.plural}"
      end
    end

    ret
  end

end
