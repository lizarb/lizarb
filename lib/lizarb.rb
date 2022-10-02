# frozen_string_literal: true

require "colorize"
require "pathname"
require "zeitwerk"

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

end
