class DevSystem::DevBox < Liza::Box

  # Preconfigure your bench panel
  
  configure :bench do
    # 
  end

  # Preconfigure your command panel
  
  configure :command do
    # 
    rescue_from CommandPanel::NotFoundError, with: NotFoundCommand
  end

  def self.command(...)
    self[:command].call(...)
  end

  def self.input
    self[:command].input
  end
  
  def self.pick_one(...)
    self[:command].pick_one(...)
  end
  
  def self.pick_many(...)
    self[:command].pick_many(...)
  end
  
  # Preconfigure your generator panel
  
  configure :generator do
    # 
    rescue_from GeneratorPanel::NotFoundError, with: NotFoundGenerator
  end

  # Preconfigure your log panel

  configure :log do
    # 
  end

  # Preconfigure your shell panel

  configure :shell do
    # 
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

end
