class DevSystem::TypographyShell < DevSystem::Shell

  def self.h1(text, color)
    stick color, " #{ text } ".center(100, "=")
  end

  def self.h2(text, color)
    stick color, " #{ text } ".center(100, "-")
  end

  def self.h3(text, color)
    stick color, " #{ text } ".center(100, " ")
  end

  def self.color_class klass
    return klass unless klass < Liza::Unit

    namespace, _sep, classname = klass.to_s.rpartition('::')

    if namespace.empty?
      return stick classname, Liza.const(classname).system.color
    end

    if namespace == "Liza"
      return stick klass.to_s, :white
    end

    "#{
      stick namespace, Liza.const(namespace).system.color
    }::#{
      stick classname, Liza.const(classname).color
    }"
  end

end
