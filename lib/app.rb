class App
  class Error < StandardError; end

  #

  def self.log s
    puts s
  end

  # called from exe/lizarb
  def self.call argv
    log "#{Liza::Unit.time_diff $boot_time}s to boot #{full_name}" if defined? $log_boot_low

    should_log = log_level >= 4
    puts if should_log
    log "#{self}.#{__method__}(#{argv.inspect})" if should_log
    args = argv.dup
    argv.clear

    if args[0]
      return _call_class_command(args) if args[0][0..1] == "--"
      return _call_instance_command(args) if args[0][0] == "-"
    end

    MicroSystem.box.configuration.dock if defined? MicroSystem
    DevSystem.box.configuration.command args if defined? DevSystem

    puts if should_log
  end

  def self._call_class_command(args)
    method_name = "call_#{args.shift[2..]}"
    send(method_name, *args)
  rescue NoMethodError
    raise Error, "Invalid App Command `#{args[0]}`. Define a class-method named `#{method_name}` on App", caller[1..], cause: nil
  end

  def self._call_instance_command(args)
    method_name = "call_#{args.shift[1..]}"
    new.send(method_name, *args)
  rescue NoMethodError
    raise Error, "Invalid App Command `#{args[0]}`. Define an instance-method named `#{method_name}` on App", caller[1..], cause: nil
  end

  def self.root
    Lizarb.root
  end

  def self.filename
    root.join "#{$APP}.rb"
  end

  def self.file
    filename
  end

  def self.call_version
    puts "LizaRB v#{Lizarb::VERSION}"
  end

  def call_v
    puts "LizaRB v#{Lizarb::VERSION}"
  end

  # directory

  def self.directory(
    directory = nil,
    data: "dat",
    permanent: "prm",
    temporary: "tmp",
    systems: "lib"
  )
    if directory.nil?
      return @directory if @directory
      return @directory = root.join(@directory_name) if @directory_name
    end
    raise "locked" if @locked
    @directory_name = directory
    @data_directory_name = data
    @permanent_directory_name = permanent
    @temporary_directory_name = temporary
    @systems_directory_name = systems
  end

  class << self
    attr_reader :directory_name, :systems_directory_name, :data_directory_name, :permanent_directory_name, :temporary_directory_name
  end

  def self.systems_directory () = (root.join systems_directory_name)

  def self.data_directory () = (root.join data_directory_name, full_name)

  def self.permanent_directory () = (root.join permanent_directory_name, name)

  def self.temporary_directory () = (root.join temporary_directory_name, full_name)

  # framework

  def self.framework(framework = nil)
    if framework
      valid_frameworks = [:rails, :hanami]
      raise "invalid framework `#{framework.inspect}` not in #{valid_frameworks.inspect}" unless valid_frameworks.include? framework.to_sym
      @framework = framework
    else
      @framework
    end
  end

  # name

  def self.name(name = nil)
    raise "locked" if @locked
    if name
      @name = name.snakecase
    else
      @name
    end
  end

  def self.full_name
    "#{mode}_#{name}"
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

  def self.mode
    @mode ||= ENV["MODE"] || "coding"
  end

  def self.coding?
    mode == "coding"
  end

  # env_vars

  def self.env_vars *files, mandatory: false
    @env_vars ||= []
    if files.any?
      @env_vars += files
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

  def self.project?
    type == :project
  end

  def self.script_independent?
    type == :script_independent
  end

  def self.script_dependent?
    type == :script_dependent
  end

end
