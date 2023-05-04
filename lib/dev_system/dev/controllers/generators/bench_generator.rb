class DevSystem::BenchGenerator < DevSystem::ControllerGenerator

  def self.call args
    log ":call #{args}"

    name = args.shift || raise("args[0] should contain NAME")
    name = name.downcase

    new.generate_app_controller :dev, :bench, :benches, name
  end

end
