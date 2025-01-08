class Liza::UnitLoggingPart < Liza::Part

  insertion do
    
    # LOG

    def self.log_levels()=App::LOG_LEVELS
    def log_levels()= App::LOG_LEVELS
  
    def self.log(
      log_level = App::DEFAULT_LOG_LEVEL,
      object,
      unit: self,
      method_name: nil,
      sidebar: nil,
      kaller: caller
    )
      log_level = log_levels[log_level] if log_level.is_a? Symbol
      raise "invalid log_level `#{log_level}`" unless log_levels.values.include? log_level
      return unless log_level? log_level

      unit_class = unit.is_a?(Class) ? unit : unit.class
      object_class = object.is_a?(Class) ? object : object.class
  
      env = {}
      env[:type] = :log
      env[:unit] = unit
      env[:unit_class] = unit_class
      env[:method_name] = method_name
      env[:sidebar] = sidebar
      env[:message_log_level] = log_level
      env[:unit_log_level] = unit.log_level
      env[:caller] = kaller
      env[:object] = object
      env[:object_class] = object_class
  
      DevBox.logg env
    end
  
    def log(
      log_level = App::DEFAULT_LOG_LEVEL,
      object,
      unit: self,
      method_name: nil,
      sidebar: nil,
      kaller: caller
    )
      log_level = log_levels[log_level] if log_level.is_a? Symbol
      raise "invalid log_level `#{log_level}`" unless log_levels.values.include? log_level
      return unless log_level? log_level

      unit_class = unit.is_a?(Class) ? unit : unit.class
      object_class = object.is_a?(Class) ? object : object.class

      env = {}
      env[:type] = :log
      env[:unit] = unit
      env[:unit_class] = unit_class
      env[:method_name] = method_name
      env[:sidebar] = sidebar
      env[:message_log_level] = log_level
      env[:unit_log_level] = unit.log_level
      env[:caller] = kaller
      env[:object] = object
      env[:object_class] = object_class
  
      DevBox.logg env
    end
  
    def self.stick(*args)
      StickLog.new(*args)
    end
  
    def stick(*args)
      StickLog.new(*args)
    end
  
    def self.sticks(*args)
      StickLog.bundle(*args)
    end
  
    def sticks(*args)
      StickLog.bundle(*args)
    end
  
    #
  
    def self.log_level new_value = nil
      if new_value
        new_value = log_levels[new_value] if new_value.is_a? Symbol
        raise "invalid log_level `#{new_value}`" unless log_levels.values.include? new_value
        set :log_level, new_value
      else
        get :log_level
      end
    end
  
    def log_level new_value = nil
      if new_value
        new_value = log_levels[new_value] if new_value.is_a? Symbol
        raise "invalid log_level `#{new_value}`" unless log_levels.values.include? new_value
        set :log_level, new_value
      else
        get :log_level
      end
    end

    #
  
    def self.log_hash log_level = :normal, hash, prefix: "", kaller: caller[1..-1]
      prefix = prefix.to_s
      size = hash.keys.map(&:to_s).map(&:size).max
      
      hash.each do |k,v|
        log log_level, "#{prefix}#{k.to_s.ljust size} = #{v.to_s.inspect}", kaller: kaller
      end
    end
  
    def log_hash log_level = :normal, hash, prefix: "", kaller: caller[1..-1]
      prefix = prefix.to_s
      size = hash.keys.map(&:to_s).map(&:size).max
      
      hash.each do |k,v|
        log log_level, "#{prefix}#{k.to_s.ljust size} = #{v.to_s.inspect}", kaller: kaller
      end
    end

    #
  
    def self.log_array log_level = :normal, array, prefix: "", kaller: caller[1..-1]
      prefix = prefix.to_s
      size = array.size.to_s.size+1
      
      array.each.with_index do |v, i|
        log log_level, "#{prefix}#{i.to_s.ljust size} = #{v.inspect}", kaller: kaller
      end
    end
  
    def log_array log_level = :normal, array, prefix: "", kaller: caller[1..-1]
      prefix = prefix.to_s
      size = array.size.to_s.size+1
      
      array.each.with_index do |v, i|
        log log_level, "#{prefix}#{i.to_s.ljust size} = #{v.inspect}", kaller: kaller
      end
    end
  
    #
  
    def self.log?(...)= log_level?(...)
    def log?(...)= log_level?(...)
  
    def self.log_level? log_level = App::DEFAULT_LOG_LEVEL
      log_level = log_levels[log_level] if log_level.is_a? Symbol
      log_level <= self.log_level
    end
  
    def log_level? log_level = App::DEFAULT_LOG_LEVEL
      log_level = log_levels[log_level] if log_level.is_a? Symbol
      log_level <= self.log_level
    end

    section :sleep

    def self.sleep(seconds)
      log :lower, "Sleeping for #{seconds}s... #{ "| #{caller[0]}" if log? :low }"
      Kernel.sleep seconds
    end

    def sleep(seconds)
      log :lower, "Sleeping for #{seconds}s... #{ caller[0] if log? :low }"
      Kernel.sleep seconds
    end
  
  end

end
