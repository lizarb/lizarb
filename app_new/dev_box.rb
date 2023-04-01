class DevBox < Liza::DevBox

  # Set up your bench panel per the DSL in http://guides.lizarb.org/panels/bench.html
  panel :bench do
    # set :log_level, ENV["dev.bench.log_level"]
  end

  # Set up your command panel per the DSL in http://guides.lizarb.org/panels/command.html
  panel :command do
    # set :log_level, ENV["dev.command.log_level"]
  end

  # Set up your generator panel per the DSL in http://guides.lizarb.org/panels/generator.html
  panel :generator do
    # set :log_level, ENV["dev.generator.log_level"]
  end

  # Set up your command panel per the DSL in http://guides.lizarb.org/panels/log.html
  panel :log do
    # set :log_level, ENV["dev.log.log_level"]
  end

  # Set up your shell panel per the DSL in http://guides.lizarb.org/panels/shell.html
  panel :shell do
    # set :log_level, ENV["dev.shell.log_level"]
  end

  # Set up your terminal panel per the DSL in http://guides.lizarb.org/panels/terminal.html
  panel :terminal do
    # set :log_level, ENV["dev.terminal.log_level"]
  end

end
