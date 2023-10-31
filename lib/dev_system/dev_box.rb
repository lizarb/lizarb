class DevSystem::DevBox < Liza::Box

  # Configure your bench panel
  
  configure :bench do
    # set :log_level, ENV["dev.bench.log_level"]
  end

  # Configure your command panel
  
  configure :command do
    # set :log_level, ENV["dev.command.log_level"]
  end

  def self.command(...)
    self[:command].call(...)
  end

  # Configure your generator panel
  
  configure :generator do
    # set :log_level, ENV["dev.generator.log_level"]
  end

  # Configure your log panel

  configure :log do
    # set :log_level, ENV["dev.log.log_level"]
  end

  # Configure your shell panel

  configure :shell do
    # set :log_level, ENV["dev.shell.log_level"]
  end

  def self.formatters
    self[:shell].formatters
  end

  def self.converters
    self[:shell].converters
  end

  def self.converters_to
    self[:shell].converters_to
  end

  def self.format(...)
    self[:shell].format(...)
  end

  def self.format?(...)
    self[:shell].format?(...)
  end

  def self.convert(...)
    self[:shell].convert(...)
  end

  def self.convert?(...)
    self[:shell].convert?(...)
  end

  # Configure your terminal panel
  
  configure :terminal do
    # set :log_level, ENV["dev.terminal.log_level"]
  end

  def self.input
    self[:terminal].input
  end
  
  def self.pick_one(...)
    self[:terminal].pick_one(...)
  end
  
  def self.pick_many(...)
    self[:terminal].pick_many(...)
  end
  
end
