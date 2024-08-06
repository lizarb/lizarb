# frozen_string_literal: true

# This flag allows database connection tests
# ENV["DBTEST"] ||= "1"

$VERBOSE ||= ENV["VERBOSE"]
$main = self
$boot_time = Time.now

puts "$VERBOSE = true" if $VERBOSE

require_relative "lizarb/version"

module Lizarb
  class Error < StandardError; end
  class ModeNotFound < Error; end
  class SystemNotFound < Error; end

  #

  module_function

  def log s
    print "#{$boot_time.diff}s " if $log_boot_high
    puts s
  end

  # Returns Lizarb::VERSION as a Gem::Version
  def version
    @version ||= Gem::Version.new VERSION
  end

  # Returns RUBY_VERSION as a Gem::Version
  def ruby_version
    @ruby_version ||= Gem::Version.new RUBY_VERSION
  end

  def ruby_supports_raise_cause?
    RUBY_ENGINE != "jruby"
  end

  singleton_class.class_eval do
    attr_reader :root
    attr_reader :spec
    attr_reader :setup_type
    attr_reader :config_path
    #
    attr_reader :app_dir
    attr_reader :gem_dir
    attr_reader :liz_dir
    attr_reader :is_app_dir
    attr_reader :is_liz_dir
    attr_reader :is_gem_dir
  end

  # ["/path/to/lizarb.rb", 1]
  def source_location
    [__FILE__, 1]
  end

  ### Initialize LizaRB as a project
  #
  # - You must provide __FILE__ as argument to this method.
  def init_project! executable
    pwd = Dir.pwd
    $LOAD_PATH.unshift "#{pwd}/lib" if File.directory? "#{pwd}/lib"
    setup_project pwd, project: executable
    App.systems.clear if ENV["SYSTEMS"]
    load
  end

  ### Initialize LizaRB as a dependent script.
  #
  # - You must provide the app key.
  # - You may provide an array of system keys.
  def init_script_dependent!(
    *systems,
    app:
  )
    pwd = Dir.pwd
    $LOAD_PATH.unshift "#{pwd}/lib" if File.directory? "#{pwd}/lib"
    cl = caller_locations(1, 1)[0]
    
    raise Lizarb::Error, "Lizarb.#{__method__} does not support app_global, use Lizarb.sfa" if app == "app_global"
    raise Lizarb::Error, "#{app.inspect} does not start with 'app_'" unless app == "app" or app.to_s.start_with? "app_"

    segments = cl.absolute_path.split("/")
    root, script = segments[0..-3].join("/"), segments[-2..-1].join("/")

    setup_script_dependent root, script: script, script_app: app

    App.class_exec do
      self.systems.clear if systems.any?
      systems.each do |key|
        system key
      end
    end
    load
  end

  ### Initialize LizaRB as an independent script.
  #
  # - You may provide all app configurations.
  # - You may provide some dev_box configurations.
  # - You may provide an array of system keys.
  def init_script_independent!(
    *systems,
    mode: :code,
    folder: nil,
    gemfile: nil,
    log_handler: :output,
    log_boot: nil,
    log_level: nil,
    log: nil,
    pwd: 
  )
    log_boot  ||= log if log
    log_level ||= log if log
    log_boot  ||= :normal
    log_level ||= :normal
    
    cl = caller_locations(1, 1)[0]
    
    script = cl.absolute_path

    setup_script_independent pwd, script: script

    App.class_exec do
      self.gemfile gemfile if gemfile
      self.folder folder if folder
      self.log_boot log_boot
      self.log_level log_level
      self.mode mode
      system :dev
      systems.each do |key|
        system key
      end
    end
    
    load

    DevSystem::DevBox.configure :log do
      handler log_handler
    end
  end

  ### Setup Methods for Different Contexts
  #
  # The LizaRB framework provides specific setup methods for different contexts: project, script_dependent, and script_independent.
  # Each method sets the `@root` and `@setup_type` instance variables and calls the `setup` method.
  #
  # Sets up the environment for a project.
  #
  # A project is a directory that contains an application app.rb file.
  #
  def setup_project pwd, project:
    @root = pwd.to_s
    @setup_type = :project
    # NOTE: arg project is not being stored anywhere
    $APP = ENV["APP"] || "app"
    setup
  end

  ### Setup Methods for Different Contexts
  #
  # The LizaRB framework provides specific setup methods for different contexts: project, script_dependent, and script_independent.
  # Each method sets the `@root` and `@setup_type` instance variables and calls the `setup` method.
  #
  # Sets up the environment for a script.
  #
  # A script_dependent must be placed in a directory which parent directory is a project directory.
  #
  def setup_script_dependent pwd, script: , script_app:
    @root = pwd.to_s
    @setup_type = :script_dependent
    # NOTE: arg script is not being stored anywhere
    $APP = script_app
    setup
  end

  ### Setup Methods for Different Contexts
  #
  # The LizaRB framework provides specific setup methods for different contexts: project, script_dependent, and script_independent.
  # Each method sets the `@root` and `@setup_type` instance variables and calls the `setup` method.
  #
  # Sets up the environment for a script.
  #
  # A script_independent is a Ruby script that uses the global_app for its project and project directory.
  #
  def setup_script_independent pwd, script:
    @root = pwd.to_s
    @setup_type = :script_independent
    # NOTE: arg script is not being stored anywhere
    $APP = "app_global"
    setup
  end

  # The setup phase is determined by containing the least amount of code needed before requiring configuration class App.
  #
  # The `setup` method orchestrates the following steps:
  # 1. Determines the environment by setting various directory and configuration variables.
  # 2. Loads necessary Ruby extensions from the LizaRB library.
  # 3. Configures the application by loading the main application configuration file.
  # 4. Overwrites Application settings with environment variables.
  # 5. Defines log levels for the application based on the boot log level setting.
  #
  def setup
    setup_and_determine_environment
    setup_and_load_ruby_extensions
    puts "Lizarb  #{__FILE__}" if $VERBOSE
    setup_and_configure_app
    puts "App     #{@config_path}\n\n" if $VERBOSE
    setup_and_overwrite_app_settings
    setup_and_define_log_levels
  end

  # The load phase is determined by containing the least amount of code needed after requiring configuration class App.
  #
  # The `load` method orchestrates the following steps:
  # 1. Properly requires gem "bundler" for managing gem your dependencies.
  # 2. Requires essential Ruby libraries, not required by default.
  # 3. Enables or disables coding mode for debugging purposes.
  # 4. Loads environment variables from the following `.env` files.
  # 5. Requires award-winning gem Zeitwerk to manage autoloading of Ruby classes.
  # 6. Requires the Liza module, and its constants are required on demand by zeitwerk.
  # 7. Requires all system-gems, then requires each system class.
  # 8. Initializes Lizarb.loaders[1] with the systems directories and the application directory.
  #
  def load
    log "  Lizarb.#{__method__}" if $log_boot_high

    load_and_require_bundler
    load_and_require_default_gems
    load_and_define_mode
    load_and_require_dotenv
    load_and_zeitwerk
    load_and_zeitwerk_loader_0_liza
    load_and_require_system_classes
    load_and_zeitwerk_loader_1_app
    App.after if defined? App.after

    log "  Lizarb.#{__method__} done" if $log_boot_high
  end

  # called from exe/lizarb
  def exit
    exit_messages if $log_boot_normal
    super 0
  end

  def exit_messages
    info = {
      ruby: RUBY_VERSION,
      bundler: Bundler::VERSION,
      zeitwerk: Zeitwerk::VERSION,
      lizarb: VERSION,
      app: $APP,
      mode: App.mode,
      log_boot: App.log_boot,
      log_level: App.log_level,
    }
    github = "https://github.com/lizarb/lizarb"
    puts info.to_s
    puts "Report bugs at #{github}/issues"
    puts "Fork us on Github at #{github}/fork"
  end

  # This method is called internally by `setup` and is not intended for direct use.
  #
  # - Checks for the presence of its signature files (`app.rb`, `lib/lizarb.rb`, and `lizarb.gemspec`) in the current directory.
  # - Stores those boolean values in instance variables (`@is_app_dir`, `@is_liz_dir`, `@is_gem_dir`).
  # - Determines key directories (`@app_dir`, `@liz_dir`, `@gem_dir`) and configuration specs (`@spec`).
  #
  # - Prints verbose output if `$VERBOSE` is enabled.
  def setup_and_determine_environment
    if $VERBOSE
      puts "determining environment"
      puts "        Lizarb.root       = #{root.inspect}"
      puts "        Lizarb.setup_type = #{setup_type.inspect}"
      # puts "        Lizarb._project            = #{_project.inspect}" if setup_type == :project
      # puts "        Lizarb._script_dependent   = #{_script_dependent.inspect}" if setup_type == :script_dependent
      # puts "        Lizarb._script_independent = #{_script_independent.inspect}" if setup_type == :script_independent
    end
    
    # NOTE: calling an unset instance variable returns nil
    # NOTE: these file calls are pretty fast
    @is_app_dir = File.file? "#{root}/app.rb" if setup_type != :sfa
    @is_liz_dir = File.file? "#{root}/lib/lizarb.rb"
    @is_gem_dir = File.file? "#{root}/lizarb.gemspec" if @is_liz_dir

    $APP = "app_global" unless @is_app_dir

    if $VERBOSE
      puts "               Lizarb.root does #{ @is_app_dir ? "   " : "not" } have a configuration app.rb file"
      puts "               Lizarb.root does #{ @is_liz_dir ? "   " : "not" } have a lib/lizarb.rb file"
      puts "               Lizarb.root does #{ @is_gem_dir ? "   " : "not" } have a lizarb.gemspec file"
    end

    begin
      @spec    = Gem::Specification.find_by_name("lizarb")
      @gem_dir = @spec.gem_dir
    rescue Gem::MissingSpecError
      @gem_dir = root
    end
    @app_dir = @is_app_dir ? root : @gem_dir
    @liz_dir = @is_liz_dir ? root : @gem_dir

    if $VERBOSE
      puts "                      Lizarb.spec    = #{spec}"
      puts "                      Lizarb.app_dir = #{@app_dir.inspect}"
      puts "                      Lizarb.liz_dir = #{@liz_dir.inspect}"
      puts "                      Lizarb.gem_dir = #{@gem_dir.inspect}"
      puts
    end
  end

  # This method is called internally by `setup` and is not intended for direct use.
  #
  # - Loads files from `lib/lizarb/ruby/*.rb` which reopen some of Ruby's core classes and add methods to them.
  # - Prints verbose output if `$VERBOSE` is enabled.
  #
  def setup_and_load_ruby_extensions
    puts "loading #{@liz_dir}/lib/lizarb/ruby/*.rb" if $VERBOSE
    Dir["#{@liz_dir}/lib/lizarb/ruby/*.rb"].each do |file_name|
      Kernel.load file_name
    end
  end

  # This method is called internally by `setup` and is not intended for direct use.
  #
  # - Requires the application definitions file `lizarb/app.rb`.
  # - Searches for the application configuration file `app.rb` in both the application directory and the LizaRB directory.
  # - Requires the configuration file if found.
  # - Raises an error if the configuration file is not found.
  # - Prints verbose output if `$VERBOSE` is enabled.
  #
  def setup_and_configure_app
    # This is lib/app.rb
    require "app"

    finder = \
      proc do |path, file|
        lib_name = "#{path}/#{file}"
        app_config_path = "#{lib_name}.rb"
        puts "        #{app_config_path} exists?" if $VERBOSE
        if File.file? app_config_path
          # This is app.rb
          require lib_name
          @config_folder = path
          @config_path = app_config_path
          return
        end
      end

    finder.call @app_dir, $APP unless $APP == "app_global"
    finder.call @liz_dir, $APP

    raise Error, "Could not find #{$APP}.rb in #{@app_dir} or #{@liz_dir}"
  end

  # This method is called internally by `setup` and is not intended for direct use.
  #
  # Overwrites Application settings with the following environment variables:
  #
  # - App.folder    with APP_FOLDER        example: `APP_FOLDER=app liza irb`
  # - App.log_boot  with LOG_BOOT or LOG   example: `LOG=highest liza irb`
  # - App.log_level with LOG_LEVEL or LOG  example: `LOG=highest liza irb`
  # - App.mode      with MODE              example: `MODE=production liza irb`
  # - App.gemfile   with GEMFILE           example: `GEMFILE=Gemfile liza irb`
  # - App.system    with ENV["SYSTEMS"]    example: `SYSTEMS=dev,happy,deep,lab liza irb`
  #
  def setup_and_overwrite_app_settings
    if env_app_folder = ENV["APP_FOLDER"]
      App.folder env_app_folder
    end

    if env_systems_folder = ENV["SYS_FOLDER"]
      App.sys_folder env_systems_folder
    end

    if s = ENV["LOG_BOOT"] || ENV["LOG"]
      App.log_boot (s.length == 1) ? s.to_i : s.to_sym
    end

    if s = ENV["LOG_LEVEL"] || ENV["LOG"]
      App.log_level (s.length == 1) ? s.to_i : s.to_sym
    end

    if env_mode = ENV["MODE"]
      App.mode env_mode
    end

    if env_gemfile = ENV["GEMFILE"]
      App.gemfile env_gemfile
    end

    if env_systems = ENV["SYSTEMS"]
      env_systems.split(",").each do |system|
        App.system system
      end
    end
  end

  # This method is called internally by `setup` and is not intended for direct use.
  #
  # Defines log levels for the application based on the boot log level setting:
  #
  # - Prints corresponding log messages if verbose output is enabled.
  # - Sets `$log_boot_*` global variables as `true` if application boot level settings.
  #
  # In other words:
  #
  # $log_boot_highest = true if App.log_boot >= 7 # this number is for :highest
  # $log_boot_higher  = true if App.log_boot >= 6 # this number is for :higher
  # $log_boot_high    = true if App.log_boot >= 5 # this number is for :high
  # $log_boot_normal  = true if App.log_boot >= 4 # this number is for :normal
  # $log_boot_low     = true if App.log_boot >= 3 # this number is for :low
  # $log_boot_lower   = true if App.log_boot >= 2 # this number is for :lower
  # $log_boot_lowest  = true if App.log_boot >= 1 # this number is for :lowest
  #
  def setup_and_define_log_levels
    level = App.log_boot
    is_highest = level == 7
    App::LOG_LEVELS.each do |k, v|
      puts "$log_boot_#{k} = #{v <= level}" if is_highest
      eval "$log_boot_#{k} = true" if v <= level
    end

    log "LizaRB v#{Lizarb.version}                                                                                                      https://lizarb.org" if $log_boot_lower
    log "  log_boot is set to #{App.log_boot}" if $log_boot_higher
    log "  log_level is set to #{App.log_level}" if $log_boot_higher
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Properly requires gem "bundler" for managing gem your dependencies:
  #
  # Up until now, require referred to the Ruby standard library.
  # From this point on, require will refer to what is in the Gemfile.
  #
  # - If App.gemfile is a String, sets the BUNDLE_GEMFILE environment variable to the specified gemfile.
  # - If App.gemfile is a Proc, requires Bundler inline and evaluates the gemfile block.
  # - Raises an error if App.gemfile is neither a String nor a Proc.
  #
  def load_and_require_bundler
    log "  Lizarb.#{__method__}" if $log_boot_high

    gf = App.gemfile
    case gf
    when String
      string = "#{ @config_folder }/#{ gf }"
      log "    requiring 'bundler/setup'" if $log_boot_higher
      log "      ENV['BUNDLE_GEMFILE'] = #{ string.inspect }" if $log_boot_highest
      ENV["BUNDLE_GEMFILE"] = string
      log "      require 'bundler/setup'" if $log_boot_highest
      require 'bundler/setup'
    when Proc
      string = gf.source_location
      log "    requiring 'bundler/inline' with #{ string }" if $log_boot_higher
      require 'bundler/inline'
      log "      required 'bundler/inline'" if $log_boot_highest
      gemfile(false, &gf)
    else
      raise "App.gemfile is not a String or a Proc"
    end
  rescue Gem::LoadError => e
    puts
    puts "    Bundler could not load #{e.name} version #{e.requirement}"
    puts
    puts "      Please run the following commands to fix the error:"
    3.times { puts }
    puts "        gem uninstall #{e.name} -aI"
    puts "        BUNDLE_GEMFILE=#{ENV["BUNDLE_GEMFILE"]} bundle install"
    3.times { puts }
    puts "           Error Details:"
    raise
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Requires essential Ruby libraries, not required by default:
  #
  # Requires the following default gems:
  # - `pathname` for handling file paths.
  # - `json` for JSON parsing.
  # - `time` for Time parsing.
  #
  # Converts the following instance variables to Pathname objects:
  # - `Lizarb`: `@root`, `@gem_dir`, `@config_path`
  # - `App`: `@relative_path`, `@path`
  #
  def load_and_require_default_gems
    log "  Lizarb.#{__method__}" if $log_boot_high
    
    # This local class is in the process of being moved to DevSystem::ErbShell
    log "    require 'lerb'" if $log_boot_higher
    require "lerb"
    
    log "    require 'pathname'" if $log_boot_higher
    require "pathname"
    
    # This gem is in the process of being replaced by Pathname (above)
    log "    require 'fileutils'" if $log_boot_higher
    require "fileutils"
    
    log "    require 'json'" if $log_boot_higher
    require "json"
    
    # this adds method Time.parse
    log "    require 'time'" if $log_boot_higher
    require "time"
    
    log "    require 'ostruct'" if $log_boot_higher
    require "ostruct"

    log "      fixing instance variables" if $log_boot_highest
    @root = Pathname(@root)
    @gem_dir = Pathname(@gem_dir)
    @config_path = Pathname(@config_path)

    App.instance_eval do
      @relative_path = Pathname(@relative_path)
      @path = Pathname(@path)
      @sys_relative_path = Pathname (defined? @sys_relative_path) ? @sys_relative_path : "lib"
      @sys_path = Pathname (defined? @sys_path) ? @sys_path : "#{Lizarb.app_dir}/lib"
    end
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Enables or disables coding mode for debugging purposes:
  #
  # - Sets the global `$mode` variable to the application mode.
  # - Sets the global `$coding` variable to `true` if the application mode is `:code`.
  #
  def load_and_define_mode
    log "  Lizarb.#{__method__}" if $log_boot_high

    $mode = App.mode
    log "    $mode = #{$mode.inspect}" if $log_boot_higher
    $coding = App.coding?
    log "    $coding enabled because $mode == :code | A bit slower for debugging purposes" if $coding && $log_boot_higher
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Loads environment variables from the following `.env` files, as follows:
  #
  # If App name and mode are `app_global` and `:code`       loads files `app_global.code.env`, app_global.env`
  # If App name and mode are `app`        and `:code`       loads files `app.code.env`,        app.env`
  # If App name and mode are `app`        and `:demo`       loads files `app.demo.env`,        app.env`
  # If App name and mode are `app`        and `:production` loads files `app.production.env`,  app.env`
  #
  def load_and_require_dotenv
    log "  Lizarb.#{__method__}" if $log_boot_high
    require "dotenv"
    log "    required Dotenv" if $log_boot_higher

    files = ["#{$APP}.#{$mode}.env", "#{$APP}.env"]
    Dotenv.load(*files)
    log "    Dotenv.load(*#{files.inspect})" if $log_boot_highest
  rescue LoadError
    log "    did not require Dotenv" if $log_boot_higher
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Requires award-winning gem Zeitwerk to manage autoloading of Ruby classes.
  #
  def load_and_zeitwerk
    log "  Lizarb.#{__method__}" if $log_boot_high
    require "zeitwerk"
    log "    required Zeitwerk" if $log_boot_higher

    if App.sys_folder
      path = "#{App.root}/#{App.sys_folder}"
      $LOAD_PATH << path
      log "    $LOAD_PATH << #{path}" if $log_boot_higher
    end
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Requires the Liza module, and its constants are required on demand by zeitwerk:
  #
  # - Requires the Liza module.
  # - Initializes Lizarb.loaders[0] with the liza directory.
  #
  # lib/liza.rb
  # lib/liza/unit.rb
  # lib/liza/**/*.rb
  #
  def load_and_zeitwerk_loader_0_liza
    log "  Lizarb.#{__method__}" if $log_boot_high
    require "liza"
    log "    required Liza" if $log_boot_higher

    # loaders[0] first loads Liza, then each System class

    log "    Zeitwerk loaders [0] first loads Liza, then each System class" if $log_boot_higher

    loaders << loader = Zeitwerk::Loader.new
    loader.tag = Liza.to_s

    # collapse Liza paths

    # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
    loader.collapse "#{Liza.source_location_radical}/**/*"
    loader.push_dir "#{Liza.source_location_radical}", namespace: Liza

    # loader setup

    log "      Setting up" if $log_boot_higher
    loader.enable_reloading
    log "        loader.enable_reloading" if $log_boot_highest
    loader.setup
    log "        loader.setup" if $log_boot_highest
    loader.eager_load
    log "        loader.eager_load" if $log_boot_highest
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Requires all system-gems, then requires each system class:
  #
  # - Requires all system-gems. These gems must be added to the gemfile under group :systems.
  # - Requires each system class.
  # - Freezes the App.systems hash.
  #
  def load_and_require_system_classes
    log "  Lizarb.#{__method__} (#{App.systems.count})" if $log_boot_high

    # bundle each System gem

    log "    Bundler.require :systems" if $log_boot_higherß
    Bundler.require :systems

    # load each System class

    log "      App.systems is Hash containing all system classes" if $log_boot_highest
    App.systems.keys.each do |key|
      klass = _require_system key
      App.systems[key] = klass
    end

    App.systems.freeze
  end

  def _require_system key
    key = "#{key}_system"
    log "        require '#{key}'" if $log_boot_highest
    require key
    Object.const_get key.camelize
  rescue LoadError => e
    def e.backtrace; []; end
    raise SystemNotFound, "FILE #{key}.rb not found on $LOAD_PATH", []
  end

  # This method is called internally by `load` and is not intended for direct use.
  #
  # Initializes Lizarb.loaders[1] with the systems directories and the application directory:
  #
  # - For each system found in the application file, Zeitwerk namespaces their Liza::Unit sub-classes under the Liza::System sub-class.
  #   lib/dev_system.rb
  #   lib/dev_system/**/*.rb
  #
  # - For each box found in the application directory, Zeitwerk namespaces their Liza::Controller sub-classes under Object.
  #   app/dev_box.rb
  #   app/dev/**/*.rb
  #
  def load_and_zeitwerk_loader_1_app
    log "  Lizarb.#{__method__}  (#{App.systems.count})" if $log_boot_high

    # loaders[1] first loads each System, then the App
    log "    Zeitwerk loaders [1] first loads each System, then the App" if $log_boot_higher
    loaders << loader = Zeitwerk::Loader.new

    # collapse each System paths

    App.systems.each do |k, klass|
      # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
      loader.collapse "#{klass.source_location_radical}/**/*"
      loader.push_dir "#{klass.source_location_radical}", namespace: klass
    end

    # cherrypick App paths

    app_dir = App.path
    if app_dir
      log "      Application Directory: #{app_dir}" if $log_boot_highest
      list = Dir["#{app_dir}/*"].to_set
    end

    if app_dir.nil? || list.empty?
      log "      Application Directory is empty" if $log_boot_highest
    else
      log "      Application Directory found #{list.count} items to collapse" if $log_boot_highest

      to_collapse = []

      App.systems.each do |k, klass|
        next if klass.subs.empty?

        box_dir  = "#{app_dir}/#{k}"
        box_file = "#{box_dir}_box.rb"
        next if !list.include? box_file

        log "        Found box file    #{box_file}" if $log_boot_highest
        to_collapse << box_file

        if list.include? box_dir
          log "        Found controllers #{box_dir}" if $log_boot_highest
          to_collapse << box_dir
        end
      end

      # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
      to_ignore = list - to_collapse
      to_ignore.each do |file|
        log "      Ignoring   #{file}" if $log_boot_highest
        loader.ignore file
      end

      to_collapse.each do |path|
        log "      Collapsing #{path}" if $log_boot_highest
        if path.end_with? ".rb"
          loader.collapse path
        else
          loader.collapse "#{path}/**/*"
        end
      end
      loader.collapse "#{app_dir}/*"

      loader.push_dir app_dir, namespace: Object
    end

    # loader setup

    log "      Setting up" if $log_boot_higher
    loader.enable_reloading
    log "        loader.enable_reloading" if $log_boot_highest
    loader.setup
    log "        loader.setup" if $log_boot_highest

    # App connects to systems

    App.systems.each do |system_key, system_class|
      system_class.color DevSystem::ColorShell.parse system_class.color unless system_class.color.is_a? Array
    end
  end

  # loaders

  @loaders = []
  @mutex = Mutex.new

  def loaders
    @loaders
  end

  def reload &block
    @mutex.synchronize do
      loaders[0].reload if @is_liz_dir
      loaders[1].reload
      yield if block_given?
    end

    true
  end

  def eager_load!
    loaders[1].eager_load
  end

  # naive thread management

  def thread_object_id
    Thread.current.object_id
  end

  @thread_ids = {thread_object_id => 0}
  @thread_ids_mutex = Mutex.new

  def thread_id
    @thread_ids[thread_object_id] ||=
      @thread_ids_mutex.synchronize do
        @thread_ids.count
      end
  end

end
