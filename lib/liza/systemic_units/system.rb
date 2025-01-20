class Liza::System < Liza::Unit

  def self.const name
    const_get name.to_s.camelize
  end

  #

  def self.subs
    @subs ||= []
  end

  def self.subsystems
    @subsystems ||= subs.map { [_1, const(_1)] }.to_h
  end

  # Adds a subsystem to the system
  def self.panel name
    subs << name
  end

  def self.token
    @token ||= name.gsub(/System$/, '').snakecase.to_sym
  end

  def self.box
    @box ||= self.const_get "#{token}_box".camelize
  end

  # SYSTEM

  def self.system
    self
  end
  
  # COLOR

  def self.color color = nil
    if color
      @color = color
    else
      @color
    end
  end

end
