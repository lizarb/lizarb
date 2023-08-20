class Liza::UnitClassesPart < Liza::Part

  insertion do
    
    def self.subclasses_select system:
      subclasses.select { _1.system? system }
    end

    def self.descendants_select system:
      descendants.select { _1.system? system }
    end

    def self.system? system
      system = Liza.const "#{system}_system" if system.is_a? Symbol
      system == get(:system)
    end

    def self.reload!
      Lizarb.reload
    end

    def reload!
      Lizarb.reload
    end

  end

end
