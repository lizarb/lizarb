class Liza::Unit

  # PARTS

  def self.part key, system: nil
    App.connect_part self, key, system
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

  part :unit_procedure
  part :unit_settings

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

  def self.build_log_sidebar_for source, method_key, method_sep, panel_key: nil
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
    source = Liza::Unit.build_log_sidebar_for self, method_key, ":"

    DevBox[:log].call "#{source} #{string}"
  end

  def log log_level = :normal, string, kaller: caller
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    method_key = _log_extract_method_name kaller

    case self
    when Liza::Panel
      source = Liza::Unit.build_log_sidebar_for box, method_key, ".", panel_key: @key
    when Liza::UnitTest
      source = Liza::Unit.build_log_sidebar_for self, " ", " "
    else
      source = Liza::Unit.build_log_sidebar_for self, method_key, "#"
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
