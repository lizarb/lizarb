# frozen_string_literal: true

$boot_time = Time.now

require "colorize"
require "json"
require "pathname"
require "fileutils"
require "lerb"

require_relative "lizarb/version"

$APP ||= "app"

module Lizarb
  class Error < StandardError; end
  class ModeNotFound < Error; end
  class SystemNotFound < Error; end

  #

  CUR_DIR = Dir.pwd
  begin
    SPEC    = Gem::Specification.find_by_name("lizarb")
    GEM_DIR = SPEC.gem_dir
  rescue Gem::MissingSpecError
    SPEC    = nil
    GEM_DIR = CUR_DIR
  end

  IS_APP_DIR = File.file? "#{CUR_DIR}/app.rb"
  IS_LIZ_DIR = File.file? "#{CUR_DIR}/lib/lizarb.rb"
  IS_GEM_DIR = File.file? "#{CUR_DIR}/lizarb.gemspec"

  APP_DIR = IS_APP_DIR ? CUR_DIR : GEM_DIR

  $APP = "app_global" if not IS_APP_DIR

  #

  module_function

  def log s
    print "#{$boot_time.diff}s " if defined? $log_boot_low
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

  # called from exe/lizarb
  def setup
    lookup_and_load_core_ext
    lookup_and_set_gemfile
  end

  # called from exe/lizarb
  def app &block
    require "app"
    if block_given?
      App.class_exec(&block)
    else
      lookup_and_require_app
    end
  end

  # called from exe/lizarb
  def call
    level = App.log_boot
    is_lowest = level == -3
    App::LOG_LEVELS.each do |k, v|
      puts "$log_boot_#{k} = #{v >= level}" if level == -3
      eval "$log_boot_#{k} = true" if v >= level
    end
    log "LizaRB v#{Lizarb.version}                                                                                                      https://lizarb.org" if defined? $log_boot_high
    log "#{self}.#{__method__}" if defined? $log_boot_normal

    lookup_and_set_mode
    lookup_and_require_dependencies
    lookup_and_load_settings
    require_liza_and_systems
    connect_systems
  end

  # called from exe/lizarb
  def exit
    exit_messages if defined? $log_boot_normal
    super 0
  end

  def exit_messages
    info = {
      ruby: RUBY_VERSION,
      bundler: Bundler::VERSION,
      zeitwerk: Zeitwerk::VERSION,
      lizarb: VERSION,
      app: $APP,
      mode: $MODE,
      log_boot: App.log_boot,
      log_level: App.get(:log_level),
    }
    github = "https://github.com/lizarb/lizarb"
    puts info.to_s
    puts "Report bugs at #{github}/issues"
    puts "Fork us on Github at #{github}/fork"
  end

  # setup phase

  def lookup_and_load_core_ext
    files =
      if IS_GEM_DIR
        Dir["#{CUR_DIR}/lib/lizarb/ruby/*.rb"]
      else
        Dir["#{GEM_DIR}/lib/lizarb/ruby/*.rb"] + Dir["#{CUR_DIR}/lib/lizarb/ruby/*.rb"]
      end

    files.each do |file_name|
      log "#{self} loading #{file_name}" if $VERBOSE
      load file_name
    end
  end

  def lookup_and_set_gemfile
    gemfile = nil

    finder = \
      proc do |file_name|
        log "#{self}.#{__method__} #{file_name}" if $VERBOSE
        if File.file? file_name
          file_name
        else
          false
        end
      end

    gemfile ||= finder.call "#{CUR_DIR}/#{$APP}.gemfile.rb"
    gemfile ||= finder.call "#{GEM_DIR}/#{$APP}.gemfile.rb" unless IS_GEM_DIR
    gemfile ||= finder.call "#{CUR_DIR}/Gemfile"
    gemfile ||= finder.call "#{GEM_DIR}/app_global.gemfile.rb"

    log "#{self} setting BUNDLE_GEMFILE to #{gemfile}" if $VERBOSE
    ENV["BUNDLE_GEMFILE"] = gemfile
  end

  # app phase

  def lookup_and_require_app
    finder = \
      proc do |lib_name, file_name|
        log "#{self} checking if #{file_name} exists" if $VERBOSE
        if File.file? "#{file_name}"
          require lib_name
          true
        else
          false
        end
      end

    return if finder.call "#{CUR_DIR}/#{$APP}", "#{CUR_DIR}/#{$APP}.rb"
    return if finder.call "#{GEM_DIR}/#{$APP}", "#{GEM_DIR}/#{$APP}.rb"

    raise Error, "Could not find #{$APP}.rb in #{CUR_DIR} or #{GEM_DIR}"
  end

  # call phase

  def lookup_and_set_mode
    log "  Lizarb.#{__method__}" if defined? $log_boot_low

    $mode = App.mode
    log "    $mode = #{$mode.inspect}" if defined? $log_boot_lower
    $coding = $mode == :code
    log "    $coding enabled because $mode == :code | A bit slower for debugging purposes" if $coding && defined? $log_boot_lower
  end

  def lookup_and_require_dependencies
    log "  Lizarb.#{__method__}" if defined? $log_boot_low
    require "bundler/setup"
    Bundler.require :default, *App.systems.keys
  end

  def lookup_and_load_settings
    log "  Lizarb.#{__method__}" if defined? $log_boot_low
    files = ["#{$APP}.#{$mode}.env", "#{$APP}.env"]
    require "dotenv"
    Dotenv.load(*files)
  end

  def require_liza_and_systems
    log "  Lizarb.#{__method__}" if defined? $log_boot_low

    log "    require Zeitwerk and Liza" if defined? $log_boot_lower

    require "zeitwerk"
    require "liza"

    # loaders[0] first loads Liza, then each System class

    log "    Zeitwerk loaders [0] first loads Liza, then each System class" if defined? $log_boot_lower

    loaders << loader = Zeitwerk::Loader.new
    loader.tag = Liza.to_s

    # collapse Liza paths

    # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
    loader.collapse "#{Liza.source_location_radical}/**/*"
    loader.push_dir "#{Liza.source_location_radical}", namespace: Liza

    # loader setup

    loader.enable_reloading
    loader.setup

    # App settings are copied to Liza::Unit

    log "      App settings are copied to Liza::Unit" if defined? $log_boot_lowest
    App.settings.each do |k, v|
      Liza::Unit.set k, v
    end

    # load each System class

    log "      App.systems is Hash containing all system classes" if defined? $log_boot_lowest
    App.systems.keys.each do |k|
      key = "#{k}_system"

      require_system key
      klass = Object.const_get key.camelize

      App.systems[k] = klass
    end

    App.systems.freeze

    # loaders[1] first loads each System, then the App
    log "    Zeitwerk loaders [1] first loads each System, then the App" if defined? $log_boot_lower
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
      log "      Application Directory: #{app_dir}" if defined? $log_boot_lowest
      list = Dir["#{app_dir}/*"].to_set
    end

    if app_dir.nil? || list.empty?
      log "      Application Directory is empty" if defined? $log_boot_lowest
    else
      log "      Application Directory found #{list.count} items to collapse" if defined? $log_boot_lowest

      to_collapse = []

      App.systems.each do |k, klass|
        box_dir  = "#{app_dir}/#{k}"
        box_file = "#{box_dir}_box.rb"

        if !list.include? box_file
          log "        Missd box file    #{box_file}" if defined? $log_boot_lowest
        else
          log "        Found box file    #{box_file}" if defined? $log_boot_lowest
          to_collapse << box_file

          if !list.include? box_dir
            log "        Missd controllers #{box_dir}" if defined? $log_boot_lowest
          else
            log "        Found controllers #{box_dir}" if defined? $log_boot_lowest
            to_collapse << box_dir
          end
        end
      end

      # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
      to_ignore = list - to_collapse
      to_ignore.each do |file|
        log "      Ignoring   #{file}" if $log_boot_lowest
        loader.ignore file
      end

      to_collapse.each do |path|
        log "      Collapsing #{path}" if $log_boot_lowest
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

    loader.enable_reloading
    loader.setup

    # App connects to systems

    log "    Zeitwerk loaders eager load" if defined? $log_boot_lowest
    loaders.map &:eager_load
  end

  def connect_systems
    log "  Lizarb.#{__method__}" if defined? $log_boot_low
    App.systems.each do |system_key, system_class|
      connect_system system_key, system_class
      connect_box system_key, system_class
    end
  end

  # systems

  def require_system key
    log "        require '#{key}'" if defined? $log_boot_lowest
    require key
  rescue LoadError => e
    def e.backtrace; []; end
    raise SystemNotFound, "FILE #{key}.rb not found on $LOAD_PATH", []
  end

  def connect_system key, system_class
    t = Time.now
    puts if defined? $log_boot_low

    color_system_class = system_class.to_s.colorize system_class.log_color

    log "CONNECTING SYSTEM                     #{color_system_class}" if defined? $log_boot_low
    index = 0
    system_class.registrar.each do |string, target_block|
      reg_type, _sep, reg_target = string.to_s.lpartition "_"

      index += 1

      target_klass = Liza.const reg_target

      if reg_type == "insertion"
        target_klass.class_exec(&target_block)
      else
        raise "TODO: decide and implement system extension"
      end
      log "CONNECTING SYSTEM-PART                #{color_system_class}.#{reg_type.to_s.ljust 11} to #{target_klass.to_s.ljust 30} at #{target_block.source_location * ":"}  " if defined? $log_boot_low
    end
    log "CONNECTING SYSTEM         #{t.diff}s for #{  color_system_class.ljust_blanks 35  } to connect to #{index} system parts" if defined? $log_boot_normal
  end

  def connect_box key, system_class
    t = Time.now

    color_system_class = system_class.to_s.colorize system_class.log_color

    if system_class.box?
      box_class = system_class.box
    else
      log "    NO BOX FOR                    #{color_system_class}" if defined? $log_boot_low
      return
    end
    
    color_box_class = box_class.to_s.colorize system_class.log_color

    log "CHECKING BOX                          #{color_box_class}" if defined? $log_boot_low
    index = 0
    system_class.subs.keys.each do |sub_key|
      # if you have a sub-system, you must have a panel and a controller of the same name
      panel_class = system_class.const "#{sub_key}_panel"
      controller_class = system_class.const sub_key

      index += 1
      log "CHECKING BOX-PANEL                    #{  "#{color_box_class}[:#{sub_key}]".ljust_blanks(35) } is an instance of #{panel_class.last_namespace.ljust_blanks 15} and it configures #{controller_class.last_namespace.ljust_blanks 10} subclasses" if defined? $log_boot_low
    end
    log "CHECKING BOX              #{t.diff}s for #{color_box_class.ljust_blanks 35} to connect to #{index} panels" if defined? $log_boot_low
  end

  # parts

  def connect_part unit_class, key, part_class, system
    if defined? $log_boot_lowest
      t = Time.now
      string = "      #{unit_class}.part :#{key}"
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

    if part_class.extension
      part_class.const_set :Extension, Class.new(Liza::PartExtension)
      part_class::Extension.class_exec(&part_class.extension)
    end

    if defined? $log_boot_lowest
      log "      ."
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
      Lizarb.loaders.map &:reload
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
