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

  #

  def setup_sfa pwd, sfa:
    @root = pwd.to_s
    @setup_type = :sfa
    # NOTE: arg sfa is not being stored anywhere
    $APP = "app_global"
    setup
  end

  def setup_project pwd, project:
    @root = pwd.to_s
    @setup_type = :project
    # NOTE: arg project is not being stored anywhere
    $APP = ENV["APP"] || "app"
    setup
  end

  def setup_script pwd, script: , script_app:
    @root = pwd.to_s
    @setup_type = :script
    # NOTE: arg script is not being stored anywhere
    $APP = script_app
    setup
  end

  # Setup sets these variables:
  #
  # root setup_type spec
  # is_app_dir is_liz_dir is_gem_dir
  #    app_dir    liz_dir    gem_dir
  #
  # The setup phase cannot get configurations from App.
  def setup
    if $VERBOSE
      puts "        Lizarb.root       = #{root.inspect}"
      puts "        Lizarb.setup_type = #{setup_type.inspect}"
      # puts "        Lizarb._sfa       = #{_sfa.inspect}" if setup_type == :sfa
      # puts "        Lizarb._project   = #{_project.inspect}" if setup_type == :project
      # puts "        Lizarb._script    = #{_script.inspect}" if setup_type == :script
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

    setup_and_load_ruby_extensions
    puts "Lizarb  #{__FILE__}" if $VERBOSE
    setup_and_configure_app
    puts "App     #{@config_path}\n\n" if $VERBOSE
  end

  # The call phase can get configurations from App, but not from any system.
  def call
    override_app_settings_with_env_variables
    define_log_levels
    log "LizaRB v#{Lizarb.version}                                                                                                      https://lizarb.org" if $log_boot_lower
    log "#{self}.#{__method__}" if $log_boot_high
    log "  log_boot is set to #{App.log_boot}" if $log_boot_higher
    log "  log_level is set to #{App.log_level}" if $log_boot_higher
    
    require_bundler
    require_default_gems
    lookup_and_set_mode
    lookup_and_load_settings
    require_liza_and_systems
    connect_systems
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
      log_level: App.get(:log_level),
    }
    github = "https://github.com/lizarb/lizarb"
    puts info.to_s
    puts "Report bugs at #{github}/issues"
    puts "Fork us on Github at #{github}/fork"
  end

  # setup phase

  def setup_and_load_ruby_extensions
    puts "loading #{@liz_dir}/lib/lizarb/ruby/*.rb" if $VERBOSE
    Dir["#{@liz_dir}/lib/lizarb/ruby/*.rb"].each do |file_name|
      Kernel.load file_name
    end
  end

  def setup_and_configure_app
    # lib/app.rb
    require "app"

    finder = \
      proc do |path, file|
        lib_name = "#{path}/#{file}"
        app_config_path = "#{lib_name}.rb"
        puts "        #{app_config_path} exists?" if $VERBOSE
        if File.file? app_config_path
          # app.rb
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

  # call phase

  def override_app_settings_with_env_variables
    if env_app_folder = ENV["APP_FOLDER"]
      App.folder env_app_folder
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

  def define_log_levels
    level = App.log_boot
    is_highest = level == 7
    App::LOG_LEVELS.each do |k, v|
      puts "$log_boot_#{k} = #{v <= level}" if is_highest
      eval "$log_boot_#{k} = true" if v <= level
    end
  end
  
  def require_bundler
    log "  Lizarb.#{__method__}" if $log_boot_high

    gf = App.gemfile
    if gf.is_a? String
      string = "#{ @config_folder }/#{ gf }"
      ENV["BUNDLE_GEMFILE"] = string
      log "    ENV['BUNDLE_GEMFILE'] = #{ string.inspect }" if $log_boot_higher
      require "bundler/setup"
    else
      string = App.gemfile.source_location
      log "    bundler inline with #{ string }" if $log_boot_higher
      require "bundler/inline"
      gemfile(false, &App.gemfile)
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

  def require_default_gems
    log "  Lizarb.#{__method__}" if $log_boot_high
    
    log "    requiring default gems" if $log_boot_higher
    log "      require 'lerb'" if $log_boot_highest
    require "lerb"
    
    log "      require 'pathname'" if $log_boot_highest
    require "pathname"
    
    log "      require 'fileutils'" if $log_boot_highest
    require "fileutils"
    
    log "      require 'json'" if $log_boot_highest
    require "json"
    
    log "      require 'time'" if $log_boot_highest
    # this adds method Time.parse
    require "time"

    log "    fixing instance variables" if $log_boot_higher
    @root = Pathname(@root)
    @gem_dir = Pathname(@gem_dir)
    @config_path = Pathname(@config_path)

    App.instance_eval do
      @relative_path = Pathname(@relative_path)
      @path = Pathname(@path)
    end
  end

  def lookup_and_set_mode
    log "  Lizarb.#{__method__}" if $log_boot_high

    $mode = App.mode
    log "    $mode = #{$mode.inspect}" if $log_boot_higher
    $coding = App.coding?
    log "    $coding enabled because $mode == :code | A bit slower for debugging purposes" if $coding && $log_boot_higher
  end

  def lookup_and_load_settings
    log "  Lizarb.#{__method__}" if $log_boot_high
    require "dotenv"
    log "    required Dotenv" if $log_boot_higher

    files = ["#{$APP}.#{$mode}.env", "#{$APP}.env"]
    Dotenv.load(*files)
    log "    Dotenv.load(*#{files.inspect})" if $log_boot_highest
  rescue LoadError
    log "    did not require Dotenv" if $log_boot_higher
  end

  def require_liza_and_systems
    log "  Lizarb.#{__method__}" if $log_boot_high

    require "zeitwerk"
    log "    required Zeitwerk" if $log_boot_higher

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

    # bundle each System gem

    Bundler.require :systems

    # load each System class

    log "      App.systems is Hash containing all system classes" if $log_boot_highest
    App.systems.keys.each do |k|
      key = "#{k}_system"

      require_system key
      klass = Object.const_get key.camelize

      App.systems[k] = klass
    end

    App.systems.freeze

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

    loaders.map &:eager_load
    log "    All Zeitwerk loaders have been eager loaded" if $log_boot_higher
  end

  def connect_systems
    log "  Lizarb.#{__method__} (#{App.systems.count})" if $log_boot_high
    App.systems.each do |system_key, system_class|
      connect_system system_key, system_class
    end
  end

  # systems

  def require_system key
    log "        require '#{key}'" if $log_boot_highest
    require key
  rescue LoadError => e
    def e.backtrace; []; end
    raise SystemNotFound, "FILE #{key}.rb not found on $LOAD_PATH", []
  end

  def connect_system key, system_class
    # t = Time.now
    system_class.color DevSystem::ColorShell.parse system_class.color unless system_class.color.is_a? Array

    # Ignore this for now.
    # This feature has been commented out for simplicity purposes.
    # It injects code into other classes just like Part does. System defines them
    #
    # color_system_class = Liza::Unit.stick(system_class.color, system_class.name).to_s
    # log "CONNECTING SYSTEM                     #{color_system_class}" if $log_boot_high
    
    # index = 0
    # system_class.registrar.each do |string, target_block|
    #   reg_type, _sep, reg_target = string.to_s.lpartition "_"

    #   index += 1

    #   target_klass = Liza.const reg_target

    #   if reg_type == "insertion"
    #     target_klass.class_exec(&target_block)
    #   else
    #     raise "TODO: decide and implement system extension"
    #   end
    #   log "CONNECTING SYSTEM-PART                #{color_system_class}.#{reg_type.to_s.ljust 11} to #{target_klass.to_s.ljust 30} at #{target_block.source_location * ":"}  " if $log_boot_high
    # end

    # pad = 21-system_class.name.size
    # log "CONNECTED  SYSTEM         #{t.diff}s for #{color_system_class}#{"".ljust pad} to connect to #{index} system parts" if $log_boot_normal
  end

  # parts

  def connect_part unit_class, key, part_class, system
    if $log_boot_highest
      t = Time.now
      string = "          #{unit_class}.part :#{key}"
      log string
    end

    part_class ||= if system.nil?
                Liza.const "#{key}_part"
              else
                Liza.const("#{system}_system")
                    .const "#{key}_part"
              end

    if part_class.insertion
      unit_class.class_exec(&part_class.insertion)
    end

    if $log_boot_highest
      log "          ."
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
      loaders.map &:reload
      yield if block_given?
    end

    true
  end

  # thread management

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
