class Liza::UnitMethodsPart < Liza::Part

  insertion do
    def self.methods_defined
      a = methods - superclass.methods
      a.reject! { _1.to_s[0] == "_" }
      a.sort!
    end

    def self.instance_methods_defined
      a = instance_methods - superclass.instance_methods
      a.reject! { _1.to_s[0] == "_" }
      a.sort!
    end

    def self.methods_for_rendering
      methods_defined.select { _1[0..5] == "render" || _1[0..2] == "erb" }.sort
    end

    def self.instance_methods_for_rendering
      instance_methods_defined.select { _1[0..5] == "render" || _1[0..2] == "erb" }.sort
    end

    def self.methods_for_logging
      array = methods_defined.select { _1[0..2] == "log" }.sort
      [*array, :stick, :sticks]
    end

    def self.instance_methods_for_logging
      array = instance_methods_defined.select { _1[0..2] == "log" }.sort
      [*array, :stick, :sticks]
    end
  end

end
