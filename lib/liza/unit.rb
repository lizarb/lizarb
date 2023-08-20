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

  LOG_LEVELS = {
    :higher => 2,
    :high   => 1,
    :normal => 0,
    :low    => -1,
    :lower  => -2,
  }

  set :log_level, :normal
  set :log_color, :white
  set :log_erb, false
  set :log_render, false

  def self.log log_level = :normal, object, kaller: caller
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    env = {}
    env[:type] = :log
    env[:unit] = self
    env[:unit_class] = self
    # env[:log_level_required] = log_level
    # env[:unit_log_level] = self.log_level
    env[:caller] = kaller
    env[:object] = object

    DevBox[:log].call env
  end

  def log log_level = :normal, object, kaller: caller
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    env = {}
    env[:type] = :log
    env[:unit] = self
    env[:unit_class] = self.class
    # env[:log_level_required] = log_level
    # env[:unit_log_level] = self.log_level
    env[:caller] = kaller
    env[:object] = object

    DevBox[:log].call env
  end

  #

  def self.log_level
    get(:log_level) || :normal
  end

  def self.log_level? log_level = :normal
    # TODO
    true
  end

  def self.log_color
    system.get :log_color
  end

  def self.log?(log_level = :normal)= log_level? log_level
  def log_level(...)= self.class.log_level(...)
  def log?(...)= self.class.log?(...)
  def log_level?(...)= self.class.log_level?(...)
  def log_color(...)= self.class.log_color(...)

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
