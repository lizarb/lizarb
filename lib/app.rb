class App
  class Error < StandardError; end

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

  def self.cwd
    Pathname Dir.pwd
  end

  @root = cwd

  def self.root
    @root
  end

  def self.filename
    root.join "#{$APP}.rb"
  end

  # path

  def self.path path = nil
    if path
      @relative_path = Pathname(path.to_s)
      @path = Pathname("#{Lizarb::APP_DIR}/#{path}")
    else
      @path
    end
  end

  def self.relative_path
    @relative_path or raise "@relative_path not set"
  end

  # mode

  def self.mode mode = nil
    if mode
      @mode = mode.to_sym
    else
      @mode ||= (ENV["MODE"] || :code).to_sym
    end
  end

  def self.coding?
    mode == :code
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

  DEFAULT_LOG_LEVEL = 0

  LOG_LEVELS = {
    :highest => 3,
    :higher  => 2,
    :high    => 1,
    :normal  => 0,
    :low     => -1,
    :lower   => -2,
    :lowest  => -3,
  }
  @log_boot = DEFAULT_LOG_LEVEL
  set :log_level, DEFAULT_LOG_LEVEL

  def self.log_boot level = nil
    return @log_boot if level.nil?
    level = LOG_LEVELS[level] if level.is_a? Symbol
    raise Error, "invalid log level `#{level}`", caller unless LOG_LEVELS.values.include? level

    @log_boot = level
  end

  def self.log_level level
    level = LOG_LEVELS[level] if level.is_a? Symbol
    raise Error, "invalid log level `#{level}`", caller unless LOG_LEVELS.values.include? level

    set :log_level, level
  end

  # helpers

  def self.global?
    $APP == "app_global"
  end

end
