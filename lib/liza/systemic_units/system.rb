class Liza::System < Liza::Unit

  def self.const name
    const_get name.to_s.camelize
  end

  def self.find_controller(family, name)
    const "#{name}_#{family}"
  end

  #

  def self.subs
    @subs ||= []
  end

  def self.subsystems
    return @subsystems if @subsystems
    ret = subs.map { [_1, const(_1)] }.to_h
    @subsystems = ret unless App.coding?
    ret
  end

  # Adds a subsystem to the system
  def self.panel name
    subs << name
  end

  def self.token
    @token ||= name.gsub(/System$/, '').snakecase.to_sym
  end

  def self.box
    return @box if @box
    ret = const "#{token}_box"
    @box = ret unless App.coding?
    ret
  end

  # SYSTEM

  def self.system
    self
  end

  def self.system_directory () = (@system_directory ||= Pathname source_location_radical)

  def self.writable? () = (return @writable if defined? @writable; @writable = source_location_radical.start_with? App.systems_directory.to_s)

  # COLOR

  def self.color color = nil
    if color
      @color = color
    else
      @color
    end
  end

end
