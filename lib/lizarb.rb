# frozen_string_literal: true

require "colorize"
require "json"
require "pathname"
require "zeitwerk"
require "lerb"

require_relative "lizarb/version"

$APP ||= "app"

module Lizarb
  class Error < StandardError; end

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

  # called from exe/lizarb
  def call
    # lookup phase
    lookup_and_load_core_ext
    lookup_and_set_gemfile
    lookup_and_require_app
    lookup_and_require_dependencies

    # call phase
    App.call ARGV

    # exit phase
    versions = {ruby: RUBY_VERSION, bundler: Bundler::VERSION, zeitwerk: Zeitwerk::VERSION, lizarb: VERSION, app: $APP}
    bugs = SPEC.metadata["bug_tracker_uri"]
    puts versions.to_s.green
    puts "Report bugs at #{bugs}"
  end

  # lookup phase

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

  def lookup_and_require_app
    require "app"

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

  def lookup_and_require_dependencies
    require "bundler/setup"
    Bundler.require :default, *App.systems.keys
  end

  # threads

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
