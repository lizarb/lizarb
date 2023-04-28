class Liza::Unit

  # PARTS

  def self.part key, system: nil
    App.connect_part self, key, system
  end

  # CONST MISSING

  if Lizarb.ruby_supports_raise_cause?

    def self.const_missing name
      Liza.const name
    rescue Liza::ConstNotFound => e
      raise NameError, "uninitialized constant #{name}", caller[1..], cause: nil
    end

  else

    def self.const_missing name
      Liza.const name
    rescue Liza::ConstNotFound => e
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

  #

  LOG_JUST = 40

  def self.log log_level = :normal, string
    raise "invalid log_level `#{log_level}`" unless LOG_LEVELS.keys.include? log_level
    return unless log_level? log_level

    source = (self.is_a? Class) ? self : self.class
    source = source.to_s.ljust(LOG_JUST).bold.colorize(source.log_color)

    string = "#{source} #{string}"

    DevBox[:log].call string
  end

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
  def log(...)= self.class.log(...)
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
