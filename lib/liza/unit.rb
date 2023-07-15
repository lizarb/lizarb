class Liza::Unit

  # ERROR
  
  class Error < Liza::Error; end

  # PART

  def self.part key, klass = nil, system: nil
    App.connect_part self, key, klass, system
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

  # NOTE: improve logs performance and readability

  LOG_JUST = 60

  def self._log_sidebar_for source, method_key, method_sep, panel_key: nil
    source = (source.is_a? Class) ? source : source.class
    source_color = source.log_color
    source = source.to_s

    s = source.bold.colorize(source_color)
    s << "[:#{panel_key}]" if panel_key
    s << "#{method_sep}#{method_key}"
    s.ljust(LOG_JUST)
  end

  # NOTE: This code needs to be optimized.
  def self._log_extract_method_name kaller
    kaller.each do |s|
      t = s.match(/`(.*)'/)[1]

      next if t.include? " in <class:"
      return t.split(" ").last if t.include? " in "
      
      next if t == "log"
      next if t == "each"
      next if t == "map"
      next if t == "with_index"
      next if t == "instance_exec"
      next if t.start_with? "_"
      return t
    end

    raise "there's something wrong with kaller"
  end

  def _log_extract_method_name kaller
    self.class._log_extract_method_name kaller
  end

  def self.log log_level = :normal, string, kaller: caller
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    method_key = _log_extract_method_name kaller
    source = Liza::Unit._log_sidebar_for self, method_key, ":"

    DevBox[:log].call "#{source} #{string}"
  end

  def log log_level = :normal, string, kaller: caller
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    method_key = _log_extract_method_name kaller

    case self
    when Liza::Panel
      source = Liza::Unit._log_sidebar_for box, method_key, ".", panel_key: @key
    when Liza::UnitTest
      source = Liza::Unit._log_sidebar_for self, " ", " "
    else
      source = Liza::Unit._log_sidebar_for self, method_key, "#"
    end

    DevBox[:log].call "#{source} #{string}"
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
    (get(:system) || self).get :log_color
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

  # SYSTEM

  def self.inherited_explicitly_sets_system

    def self.inherited sub
      super

      return unless sub.name.to_s.include? "::"

      system = Object.const_get sub.first_namespace

      sub.set :system, system
    end

  end

end

__END__

# view render.txt.erb
<%= render if render_stack.any? -%>
