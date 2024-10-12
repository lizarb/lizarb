class App
  class Error < StandardError; end

  #

  def self.log s
    puts s
  end

  # called from exe/lizarb
  def self.call argv
    log "#{$boot_time.diff}s to boot" if defined? $log_boot_low

    should_log = log_level >= 4
    puts if should_log
    log "#{self}.#{__method__}(#{argv.inspect})" if should_log
    args = argv.dup
    argv.clear
    Liza[:DevBox].command args
    puts if should_log
  end

  def self.root
    Lizarb.root
  end

  def self.filename
    root.join "#{$APP}.rb"
  end

  # folder

  def self.directory(directory = nil, systems: nil)
    folder directory, systems: systems
  end

  def self.folder folder = nil, systems: nil
    raise "locked" if @locked
    if folder
      @folder = folder
      @relative_path = folder
      @path = "#{Lizarb.app_dir}/#{folder}"
      self.sys_folder systems if systems
    else
      @folder
    end
  end

  def self.path
    @path
  end

  def self.relative_path
    @relative_path or raise "@relative_path not set"
  end

  def self.sys_folder sys_folder = nil
    raise "locked" if @locked
    if sys_folder
      @sys_folder = sys_folder
      @sys_relative_path = sys_folder
      @sys_path = "#{Lizarb.app_dir}/#{sys_folder}"
    else
      @sys_folder
    end
  end

  def self.sys_path
    @sys_path
  end

  def self.sys_relative_path
    @sys_relative_path or raise "@sys_relative_path not set"
  end

  # gemfile

  def self.gemfile(gemfile = :unset, &block)
    raise "locked" if @locked
    if block_given?
      @gemfile = block
    elsif gemfile != :unset
      @gemfile = gemfile
    else
      @gemfile
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

  def self.coding?
    mode == :code
  end

  # env_vars

  def self.env_vars *files, mandatory: false
    @env_vars ||= []
    if files.any?
      mode = self.mode.to_s
      @env_vars += files.map { _1.sub(":directory", directory).sub(":mode", mode) }
      @env_vars_mandatory = mandatory
    end
    @env_vars
  end

  def self.env_vars_mandatory?
    @env_vars_mandatory
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

  DEFAULT_LOG_LEVEL = 4

  LOG_LEVELS = {
    :highest => 7,
    :higher  => 6,
    :high    => 5,
    :normal  => 4,
    :low     => 3,
    :lower   => 2,
    :lowest  => 1,
  }
  @log_boot = DEFAULT_LOG_LEVEL
  @log_level = DEFAULT_LOG_LEVEL

  def self.log_boot level = nil
    return @log_boot if level.nil?
    level = LOG_LEVELS[level] if level.is_a? Symbol
    raise Error, "invalid log level `#{level}`", caller unless LOG_LEVELS.values.include? level

    @log_boot = level
  end

  def self.log_level level = nil
    return @log_level if level.nil?
    level = LOG_LEVELS[level] if level.is_a? Symbol
    raise Error, "invalid log level `#{level}`", caller unless LOG_LEVELS.values.include? level

    @log_level = level
  end

  # helpers

  def self.global?
    $APP == "app_global"
  end

  #

  def self.type
    Lizarb.setup_type
  end

  def self.sfa?
    type == :sfa
  end

  def self.project?
    type == :project
  end

  def self.script?
    type == :script
  end

end
