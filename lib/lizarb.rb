# frozen_string_literal: true

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
    puts s.bold
  end

  def self.logv s
    log s if $VERBOSE
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
    lookup_and_set_mode
    lookup_and_require_dependencies
    lookup_and_load_settings
    require_liza_and_bundle_systems
  end

  # called from exe/lizarb
  def exit
    verbose = $VERBOSE || (ENV["LOG_VERSIONS"] != "")
    exit_messages if verbose
    super 0
  end

  def exit_messages
    versions = {
      ruby: RUBY_VERSION,
      bundler: Bundler::VERSION,
      zeitwerk: Zeitwerk::VERSION,
      lizarb: VERSION,
      app: $APP,
      mode: $MODE
    }
    github = "https://github.com/lizarb/lizarb"
    puts versions.to_s.green
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
    raise ModeNotFound, "App #{$APP} has no modes" if App.modes.empty?

    mode = ENV["MODE"]
    mode ||= App.modes.first
    mode = mode.to_sym

    raise ModeNotFound, "MODE `#{mode}` is not included in #{App.modes}" unless App.modes.include? mode

    log "#{self}.#{__method__} #{mode.inspect}" if $VERBOSE
    $MODE = mode
  end

  def lookup_and_require_dependencies
    require "bundler/setup"
    Bundler.require :default, *App.systems.keys
  end

  def lookup_and_load_settings
    files = ["#{$APP}.#{$MODE}.env", "#{$APP}.env"]
    require "dotenv"
    Dotenv.load(*files)
  end

  def require_liza_and_bundle_systems
    log "LizaRB v#{Lizarb.version}                                                                                                      https://lizarb.org"

    require "zeitwerk"
    require "liza"

    # App.loaders[0] first loads Liza, then each System class
    App.loaders << loader = Zeitwerk::Loader.new
    loader.tag = Liza.to_s

    # collapse Liza paths

    # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
    loader.collapse "#{Liza.source_location_radical}/**/*"
    loader.push_dir "#{Liza.source_location_radical}", namespace: Liza

    # loader setup

    loader.enable_reloading
    loader.setup
    # load each System class

    App.systems.keys.each do |k|
      key = "#{k}_system"

      App.require_system key
      klass = Object.const_get key.camelize

      App.systems[k] = klass
    end

    # App.loaders[1] first loads each System, then the App
    App.loaders << loader = Zeitwerk::Loader.new

    # collapse each System paths

    App.systems.each do |k, klass|
      # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
      loader.collapse "#{klass.source_location_radical}/**/*"
      loader.push_dir "#{klass.source_location_radical}", namespace: klass
    end

    # cherrypick App paths

    app_dir = "#{APP_DIR}/#{$APP}"
    logv "Lizarb app loader #{app_dir}".on_cyan
    list = Dir["#{app_dir}/*"].to_set
    logv "Lizarb app loader lists #{list.count} entries to review".on_cyan

    if list.empty?
      logv "no #{app_dir} found".red
    else
      logv "Lizarb app loader found #{app_dir}\t\tCollapsing #{app_dir}/*".on_cyan

      to_collapse = []

      App.systems.each do |k, klass|
        box_dir  = "#{app_dir}/#{k}"
        box_file = "#{box_dir}_box.rb"

        if !list.include? box_file
          logv "Lizarb app loader missd #{box_file}".on_light_black
        else
          logv "Lizarb app loader found #{box_file}\t\tto_collapse!".on_cyan
          to_collapse << box_file

          if !list.include? box_dir
            logv "Lizarb app loader missd #{box_dir}".on_light_black
          else
            logv "Lizarb app loader found #{box_dir}\t\tto_collapse!".on_cyan
            to_collapse << box_dir
          end
        end
      end

      # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
      to_ignore = list - to_collapse
      to_ignore.each do |file|
        logv "Lizarb app loader missd #{file}\t\tSkipping this one".on_light_black
        loader.ignore file
      end

      to_collapse.each do |path|
        logv "Lizarb app loader collapsing #{path}".on_cyan
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
    logs_system = ENV["LOG_SYSTEMS"] != ""
    logs_box = ENV["LOG_BOXES"] != ""

    App.systems.freeze

    App.loaders.map &:eager_load

    App.systems.each do |system_key, system_class|
      App.connect_system system_key, system_class, logs_system
      App.connect_box system_key, system_class, logs_box
    end
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
