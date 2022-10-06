module Liza
  class Panel < Unit
    inherited_explicitly_sets_system

    def self.on_connected box_klass
      set :box, box_klass
    end

    def self.box
      get :box
    end

    def box
      self.class.box
    end

    def initialize name
      @name = name
    end

    def log string
      source = box.to_s

      x = source.size

      source = source.bold.colorize log_color

      y = source.size

      source = "#{source}.#{@name}".ljust(LOG_JUST+y-x)

      string = "#{source} #{string}"

      super string
    end

  end
end
