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
    @subs ||= {}
  end

  def self.sub name
    subs[name.to_sym] = nil
  end

  def self.token
    @token ||= name.gsub(/System$/, '').snakecase.to_sym
  end

  def self.box
    @box ||= Liza.const "#{token}_box"
  rescue Liza::ConstNotFound
    nil
  end

  def self.box?
    !!box
  end

end
