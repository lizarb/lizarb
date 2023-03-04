class DevSystem::DevBox < Liza::Box

  # Set up your command panel per the DSL in http://guides.lizarb.org/panels/command.html
  panel :command do
    # set :log_level, ENV["dev.command.log_level"]
  end

  # Set up your command panel per the DSL in http://guides.lizarb.org/panels/log.html
  panel :log do
    # set :log_level, ENV["dev.log.log_level"]
  end

  has_controller :command, :command
  has_controller :bench, :command
  has_controller :shell, :command
  has_controller :terminal, :command
end
