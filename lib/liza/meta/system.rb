class Liza::System < Liza::Unit

  def self.const name
    const_get name.to_s.camelize
  end

  # Ignore this for now.
  # This feature has been commented out for simplicity purposes.
  # It injects code into other classes just like Part does. Lizarb connects them

  # def self.insertion key, &block
  #   if block_given?
  #     registrar[:"insertion_#{key}"] = block
  #   else
  #     registrar[:"insertion_#{key}"]
  #   end
  # end

  # def self.registrar
  #   @registrar ||= {}
  # end

  #

  def self.subs
    @subs ||= []
  end

  def self.subsystems
    @subsystems ||= subs.map { const _1 }
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
