class DevSystem::TypographyShell < DevSystem::Shell

  def self.h1(text, color, length: 100)
    stick color, " #{ text } ".center(length, "=")
  end

  def self.h2(text, color, length: 100)
    stick color, " #{ text } ".center(length, "-")
  end

  def self.h3(text, color, length: 100)
    stick color, " #{ text } ".center(length, " ")
  end

  def self.color_class klass
    return klass.to_s unless klass.is_a? Class
    return klass.to_s unless klass < Liza::Unit
    return klass.to_s if klass.superclass == Liza::Unit

    namespace, _sep, classname = klass.to_s.rpartition('::')

    return stick classname, klass.system.color if namespace.empty?
    return stick klass.to_s, :white if namespace == "Liza"
    
    ns = Liza.const(namespace)

    "#{
      stick namespace, ns.system.color
    }::#{
      stick classname, klass.color
    }"
  end

end
