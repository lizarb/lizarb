class Liza::ControllerSubsystemPart < Liza::Part
  insertion do

    # subsystem
  
    def self.subsystem
      get :subsystem
    end
  
    def self.subsystem?
      get(:subsystem) == self
    end

    def self.subsystem! box_klass, token
      # FIRST, subsystem settings
      panel = box_klass[token]
      set :subsystem, self
      set :box, box_klass
      set :panel, panel

      # LAST, panel settings
      panel.settings.each do |k, v|
        next if settings.key? k
        set k, v
      end
    end

    # box and panel

    def self.box
      get :box
    end

    def self.panel
      get :panel
    end

    def box
      self.class.box
    end

    def panel
      self.class.panel
    end

    # division

    def self.division
      get :division
    end
  
    def self.division?
      get(:division) == self
    end
  
    def self.division!
      set :division, self
  
      camel = last_namespace
      singular = camel.snakecase.to_sym
      plural = "#{camel}s".snakecase.to_sym
      fetch(:singular) { singular }
      fetch(:plural) { plural }
    end

    # grammar

    def self.singular
      case
      when subsystem? then get :singular
      when division?  then :"#{token}_#{subsystem.singular}"
      else                 :"#{token}_#{division.singular}"
      end
    end
  
    def self.plural
      case
      when subsystem? then get :plural
      when division?  then :"#{token}_#{subsystem.plural}"
      else                 :"#{token}_#{division.plural}"
      end
    end
    
    def self.token
      if subsystem?
        nil
      elsif division?
        last_namespace.gsub(/#{subsystem.last_namespace}$/, '').snakecase.to_sym
      else
        last_namespace.gsub(/#{division.last_namespace}$/, '').snakecase.to_sym
      end
    end
  
  end
end
