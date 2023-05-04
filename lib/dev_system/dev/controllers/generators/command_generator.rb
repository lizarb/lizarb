class DevSystem::CommandGenerator < DevSystem::ControllerGenerator

  def self.call args
    log ":call #{args}"

    name = args.shift || raise("args[0] should contain NAME")
    name = name.downcase

    new.generate_app_controller :dev, :command, :commands, name
  end

end

__END__

# view install_insert_panel.rb.erb

    short :b, :bench
    short :g, :generate
