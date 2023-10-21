class Liza::System < Liza::Unit

  def self.const name
    const_get name.to_s.camelize
  end

  def self.insertion key, &block
    if block_given?
      registrar[:"insertion_#{key}"] = block
    else
      registrar[:"insertion_#{key}"]
    end
  end

  def self.registrar
    @registrar ||= {}
  end

  #

  def self.subs
    @subs ||= []
  end

  def self.sub name
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
