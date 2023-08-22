class App
  class Error < StandardError; end
  class SystemNotFound < Error; end

  #

  def self.log s
    puts s
  end

  # called from exe/lizarb
  def self.call argv
    log "#{$boot_time.diff}s to boot" if defined? $log_boot_high
    puts
    args = argv.dup
    argv.clear
    Liza[:DevBox].command args
    puts
  end

  def self.root
    Pathname Dir.pwd
  end

  # dir

  def self.dir dir = nil
    if dir
      @dir = Pathname("#{Lizarb::APP_DIR}/#{dir}")
    else
      @dir
    end
  end

  # mode

  def self.mode mode = nil
    if mode
      @mode = mode.to_sym
    else
      @mode ||= (ENV["MODE"] || :code).to_sym
    end
  end

  # systems

  @systems = {}

  def self.system key
    raise "locked" if @locked
    @systems[key] = nil
  end

  def self.systems
    @systems
  end

  # settings

  def self.settings
    @settings ||= {}
  end

  def self.set key, value
    settings[key] = value
  end

  def self.get key
    settings[key]
  end

  # advanced settings

  LOG_LEVELS = {
    :highest => 3,
    :higher  => 2,
    :high    => 1,
    :normal  => 0,
    :low     => -1,
    :lower   => -2,
    :lowest  => -3,
  }
  @log_boot = 0

  def self.log_boot level = nil
    return @log_boot if level.nil?
    level = LOG_LEVELS[level] if level.is_a? Symbol
    raise "invalid log level `#{level}`" unless level.is_a? Integer

    @log_boot = level
  end

end
