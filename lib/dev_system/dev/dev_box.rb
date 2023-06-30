class DevSystem::DevBox < Liza::Box

  # Configure your bench panel per the DSL in http://guides.lizarb.org/panels/bench.html
  configure :bench do
    # set :log_level, ENV["dev.bench.log_level"]
  end

  # Configure your command panel per the DSL in http://guides.lizarb.org/panels/command.html
  configure :command do
    # set :log_level, ENV["dev.command.log_level"]
  end

  # Configure your generator panel per the DSL in http://guides.lizarb.org/panels/generator.html
  configure :generator do
    # set :log_level, ENV["dev.generator.log_level"]
  end

  def self.formatters
    self[:generator].formatters
  end

  def self.converters
    self[:generator].converters
  end

  def self.converters_to
    self[:generator].converters_to
  end

  def self.format(...)
    self[:generator].format(...)
  end

  def self.format?(...)
    self[:generator].format?(...)
  end

  def self.convert(...)
    self[:generator].convert(...)
  end

  def self.convert?(...)
    self[:generator].convert?(...)
  end

  # Configure your command panel per the DSL in http://guides.lizarb.org/panels/log.html
  configure :log do
    # set :log_level, ENV["dev.log.log_level"]
  end

  # Configure your shell panel per the DSL in http://guides.lizarb.org/panels/shell.html
  configure :shell do
    # set :log_level, ENV["dev.shell.log_level"]
  end

  # Configure your terminal panel per the DSL in http://guides.lizarb.org/panels/terminal.html
  configure :terminal do
    # set :log_level, ENV["dev.terminal.log_level"]
  end

end
