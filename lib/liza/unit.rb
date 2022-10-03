module Liza
  class Unit

    # PARTS

    def self.part key
      App.connect_part self, key
    end

    # LOG

    def self.log s
      puts s
    end

    def log s
      puts s
    end

  end
end
