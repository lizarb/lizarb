# frozen_string_literal: true

require "colorize"
require "json"
require "pathname"
require "zeitwerk"
require "lerb"

require_relative "lizarb/version"

module Lizarb
  class Error < StandardError; end

  #

  GEM_DIR = Gem::Specification.find_by_name("lizarb").gem_dir
  CUR_DIR = Dir.pwd

  IS_APP_DIR = File.file? "#{CUR_DIR}/app.rb"
  IS_LIZ_DIR = File.file? "#{CUR_DIR}/lib/lizarb.rb"

  APP_DIR = IS_APP_DIR ? CUR_DIR : GEM_DIR

  #

  module_function

  def log s
    puts s.bold
  end

  # called from exe/lizarb
  def call
    require "app"

    setup_core_ext
    setup_gemfile

    require "#{APP_DIR}/app"

    VERSION
  end

  # called from "#{APP_DIR}/app"
  def bundle
    require "bundler/setup"
    Bundler.require :default

    bundle_liza

    check_mode!
  end

  # setup

  def setup_core_ext
    pattern =
      IS_LIZ_DIR  ? "lib/lizarb/ruby/*.rb"
                  : "#{GEM_DIR}/lib/lizarb/ruby/*.rb"

    Dir[pattern].each &method(:load)
  end

  def setup_gemfile
    ENV["BUNDLE_GEMFILE"] =
      IS_APP_DIR  ? "#{CUR_DIR}/Gemfile"
                  : "#{GEM_DIR}/exe/Gemfile"
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
