class Liza::UnitSettingPart < Liza::Part

  insertion do
    def self.settings
      @settings ||= {}
    end

    def self.get key
      return settings[key] if settings.has_key? key

      found = nil

      for klass in ancestors
        break unless klass.respond_to? :settings

        if klass.settings.has_key? key
          found = klass.settings[key]

          break
        end
      end

      found = settings[key] = found.dup if found.is_a? Enumerable

      found
    end

    def self.set key, value
      settings[key] = value
      value
    end

    def self.add list, key = nil, value
      if key
        fetch(list) { Hash.new }[key] = value
      else
        fetch(list) { Set.new } << value
      end
    end

    def self.fetch key, &block
      x = get key
      x ||= set key, instance_eval(&block)
      x
    end

    def settings
      @settings ||= {}
    end

    def get key
      return settings[key] if settings.has_key? key

      self.class.get key
    end

    def set key, value
      settings[key] = value
    end

    def add list, key = nil, value
      if key
        fetch(list) { Hash.new }[key] = value
      else
        fetch(list) { Set.new } << value
      end
    end

    def fetch key, &block
      x = get key
      x ||= set key, eval(&block)
      x
    end
  end

end
