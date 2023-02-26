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
end
