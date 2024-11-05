class Liza::UnitAssociatingPart < Liza::Part

  insertion do
    def self.namespace
      return @namespace if defined? @namespace

      @namespace ||= Object unless to_s.include? "::"
      @namespace ||= Liza if to_s.start_with? "Liza::"
      @namespace ||= system
      @namespace
    end

    def self.subclasses_select system:
      subclasses.select { _1.system? system }
    end

    def self.descendants_select system:
      descendants.select { _1.system? system }
    end

    def self.subunits
      Lizarb.eager_load! unless Lizarb.eager_loaded?
      subclasses.select { _1.name&.start_with?(/[A-Z]/) }
    end

    def self.system? system
      system = Liza.const "#{system}_system" if system.is_a? Symbol
      system == get(:system)
    end

    # TEST

    def self.test_class
      @test_class ||=
        if first_namespace == "Liza"
          Liza.const_get "#{last_namespace}Test"
        else
          Object.const_get "#{name}Test"
        end
    end

    # CONTROLLER

    def self.division
      Liza::Controller
    end

    # SYSTEM

    def self.system
      if name&.include? "::"
        return System if first_namespace == "Liza"
        Object.const_get first_namespace
      else
        superclass.system
      end
    end

    singleton_class.send :public, :system

    def system
      self.class.system
    end

    public :system

  end

end
