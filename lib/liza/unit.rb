class Liza::Unit

  # ERROR
  
  class Error < Liza::Error; end

  # PART

  def self.part key, klass = nil, system: nil
    Lizarb.connect_part self, key, klass, system
  end

  # CONST MISSING

  if Lizarb.ruby_supports_raise_cause?

    def self.const_missing name
      Liza.const name
    rescue Liza::ConstNotFound
      raise NameError, "uninitialized constant #{name}", caller[1..], cause: nil
    end

  else

    def self.const_missing name
      Liza.const name
    rescue Liza::ConstNotFound
      raise NameError, "uninitialized constant #{name}", caller[1..]
    end

  end

  # PARTS

  part :unit_classes

  part :unit_methods

  part :unit_procedure
  
  class RenderError < Error; end
  class RendererNotFound < RenderError; end
  class RenderStackIsFull < RenderError; end
  class RenderStackIsEmpty < RenderError; end
  part :unit_renderer

  part :unit_settings

  # TEST

  def self.test_class
    @test_class ||=
      if first_namespace == "Liza"
        Liza.const_get "#{last_namespace}Test"
      else
        Object.const_get "#{name}Test"
      end
  end

  # LOG

  set :log_erb, false

  def self.log_levels()= App::LOG_LEVELS
  def log_levels()= App::LOG_LEVELS

  def self.log log_level = App::DEFAULT_LOG_LEVEL, object, kaller: caller
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    raise "invalid log_level `#{log_level}`" unless log_levels.values.include? log_level
    return unless log_level? log_level

    env = {}
    env[:type] = :log
    env[:unit] = self
    env[:unit_class] = self
    env[:message_log_level] = log_level
    env[:unit_log_level] = self.log_level
    env[:caller] = kaller
    env[:object] = object

    DevBox[:log].call env
  end

  def log log_level = App::DEFAULT_LOG_LEVEL, object, kaller: caller
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    raise "invalid log_level `#{log_level}`" unless log_levels.values.include? log_level
    return unless log_level? log_level

    env = {}
    env[:type] = :log
    env[:unit] = self
    env[:unit_class] = self.class
    env[:message_log_level] = log_level
    env[:unit_log_level] = self.log_level
    env[:caller] = kaller
    env[:object] = object

    DevBox[:log].call env
  end

  def self.stick *args
    StickLog.new *args
  end

  def stick *args
    StickLog.new *args
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

  def self.log_hash hash, prefix: "", kaller: caller[1..-1]
    prefix = prefix.to_s
    size = hash.keys.map(&:to_s).map(&:size).max
    
    hash.each do |k,v|
      log "#{prefix}#{k.to_s.ljust size} = #{v.to_s.inspect}", kaller: kaller
    end
  end

  def log_hash hash, prefix: "", kaller: caller[1..-1]
    self.class.log_hash hash, prefix: prefix, kaller: kaller
  end

  def self.log_array array, prefix: "", kaller: caller[1..-1]
    prefix = prefix.to_s
    size = array.size.to_s.size+1
    
    array.each.with_index do |v, i|
      log "#{prefix}#{i.to_s.ljust size} = #{v.inspect}", kaller: kaller
    end
  end

  def log_array array, prefix: "", kaller: caller[1..-1]
    self.class.log_array array, prefix: prefix, kaller: kaller
  end

  #

  def self.log?(log_level = App::DEFAULT_LOG_LEVEL)= log_level? log_level
  def log?(...)= log_level? log_level

  def self.log_level? log_level = App::DEFAULT_LOG_LEVEL
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    log_level >= self.log_level
  end

  def log_level? log_level = App::DEFAULT_LOG_LEVEL
    log_level = log_levels[log_level] if log_level.is_a? Symbol
    log_level >= self.log_level
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

__END__

# view render.txt.erb
<%= render if render_stack.any? -%>
