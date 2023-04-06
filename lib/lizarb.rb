# frozen_string_literal: true

require "colorize"
require "json"
require "pathname"
require "lerb"

require_relative "lizarb/version"

$APP ||= "app"

module Lizarb
  class Error < StandardError; end
  class ModeNotFound < Error; end

  #

  SPEC    = Gem::Specification.find_by_name("lizarb")
  GEM_DIR = SPEC.gem_dir
  CUR_DIR = Dir.pwd

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

  def self.load_all
    Zeitwerk::Loader.eager_load_all
  end

  # called from exe/lizarb
  def setup
    lookup_and_load_core_ext
    lookup_and_set_gemfile
  end

  # called from exe/lizarb
  def app
    require "app"
    lookup_and_require_app
  end

  # called from exe/lizarb
  def call
    lookup_and_set_mode
    lookup_and_require_dependencies
    lookup_and_load_settings
    require_liza_and_bundle_systems
  end

  # called from exe/lizarb
  def exit verbose: $VERBOSE
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
    bugs = SPEC.metadata["bug_tracker_uri"]
    puts versions.to_s.green
    puts "Report bugs at #{bugs}"
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
    Dotenv.load *files
  end

  def require_liza_and_bundle_systems
    require "zeitwerk"
    require "liza"

    App.loaders << loader = Zeitwerk::Loader.new
    loader.tag = Liza.to_s

    # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
    loader.collapse "#{Liza.source_location_radical}/**/*"
    loader.push_dir "#{Liza.source_location_radical}", namespace: Liza

    loader.enable_reloading
    loader.setup

    App.systems.keys.each do |k|
      key = "#{k}_system"

      App.require_system key
      klass = Object.const_get key.camelize

      App.systems[k] = klass
    end

    App.loaders << loader = Zeitwerk::Loader.new

    App.systems.each do |k, klass|
      # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
      loader.collapse "#{klass.source_location_radical}/**/*"
      loader.push_dir "#{klass.source_location_radical}", namespace: klass
    end

    # ORDER MATTERS: IGNORE, COLLAPSE, PUSH
    loader.collapse "#{APP_DIR}/#{$APP}/**/*"
    loader.push_dir "#{APP_DIR}/#{$APP}" if Dir.exist? "#{APP_DIR}/#{$APP}"

    loader.enable_reloading
    loader.setup

    App.systems.each do |k, klass|
      App.connect_system k, klass
    end

    App.systems.freeze
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
