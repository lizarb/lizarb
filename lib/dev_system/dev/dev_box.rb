class DevSystem
  class DevBox < Liza::Box
    has_panel :command, :commands
    has_controller :command, :commands
    has_controller :shell, :commands
    has_controller :bench, :commands
    has_controller :terminal, :commands

    has_panel :log, :logs

    # Set up your command panel per the DSL in http://guides.lizarb.org/panels/command.html
    commands do
      # set :log_level, ENV["dev.command.log_level"]
    end

    # Set up your command panel per the DSL in http://guides.lizarb.org/panels/log.html
    logs do
      # set :log_level, ENV["dev.log.log_level"]
    end

  end
end
