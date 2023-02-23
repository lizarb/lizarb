# frozen_string_literal: true

# https://docs.ruby-lang.org/en/3.2/ERB.html
require "erb"

class LERB < ERB
  class Error < StandardError; end
  class BuildError < Error; end
  class ExecutionError < Error; end

  # loaders

  def self.load path_radical
    load_from_folder(path_radical) + load_from_file("#{path_radical}.rb")
  end

  def self.load_from_file path
    ret = []

    fname = path
    return ret unless File.exist? path

    lines = File.readlines fname

    lineno = lines.index "__END__\n"
    return ret if lineno.nil?

    content = lines[lineno+1..-1].join
    array = content.split(/^# (\w*).(\w*).(\w*)$/)
    # => ["", "a", "html", "erb", "\n<html>\n<a></a>\n</html>\n", "b", "html", "erb", "\n<html>\n<b></b>\n</html>"]

    while (chunk = array.pop 4; chunk.size == 4)
      # => ["b", "html", "erb", "\n<html>\n<b></b>\n</html>"]
      # => ["a", "html", "erb", "\n<html>\n<a></a>\n</html>\n"]
      key = "#{chunk[0]}.#{chunk[1]}.#{chunk[2]}"
      content = chunk[3]
      ret.push new :file, key, content, fname, lineno
    end

    ret
  end

  def self.load_from_folder path
    ret = []

    lineno = 0
    fnames = Dir.glob "#{path}/*.*.erb"
    fnames.map do |fname|
      key = fname.split("/").last
      content = File.read fname
      ret.push new :folder, key, content, fname, lineno
    end

    ret
  end

  # format

  TAG_FORMATS = %w|xml html|

  def tags?
    TAG_FORMATS.include? format
  end

  # source

  SOURCES = %i|file folder|

  def file?
    @source == :file
  end

  def folder?
    @source == :folder
  end

  # constructor

  TRIM_MODE = "<>-"

  attr_reader :source, :key, :name, :format

  def initialize source, key, content, filename, lineno
    raise BuildError, "source :#{source} must be one of #{SOURCES}" unless SOURCES.include? source

    segments = key.split("/").last.split(".")
    name, format = segments[0..1]

    # raise BuildError, "key '#{key}' must be formatted as <name>.<format>.erb" unless segments.count == 3
    # raise BuildError, "key '#{key}' must be formatted as <name>.<format>.erb" unless segments[2] == "erb"
    raise BuildError, "key '#{key}' has an invalid format '#{format}'" unless format.gsub(/[^a-z0-9]/, "") == format

    super content, trim_mode: TRIM_MODE
    @source, @key, @name, @format, self.filename, self.lineno = source, key, name, format, filename, lineno
  end

  # result

  def result the_binding, receiver=:unset
    super the_binding
  rescue NameError => e
    raise unless e.receiver == receiver
    message = "ERB template for a #{e.receiver.class} instance could not find method '#{e.name}'"
    raise ExecutionError, message, [e.backtrace[0]]
  end
end
