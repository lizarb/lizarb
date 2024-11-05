class DevSystem::ErbShell < DevSystem::Shell

  # https://docs.ruby-lang.org/en/3.2/ERB.html
  Kernel.require "erb"

  def self.load(path_radical)
    LERB.load path_radical
  end

  $LERB_VERBOSE = ENV["LERB_VERBOSE"]

  class LERB < ERB
    class Error < StandardError; end
    class BuildError < Error; end
    class ExecutionError < Error; end
  
    # output
  
    def self.puts string=nil
      super if $LERB_VERBOSE
    end
  
    # loaders
  
    DEFAULT_KEY = "inline.txt.erb"
  
    def self.load path_radical
      erbs = []
  
      "#{path_radical}.rb".tap do |filename|
        _load erbs, filename
      end
  
      Dir.glob("#{path_radical}.*.erb").each do |filename|
        _load erbs, filename
      end
  
      Dir.glob("#{path_radical}/*.*.erb").each do |filename|
        _load erbs, filename
      end
  
      #
  
      puts "#{erbs.size} erbs"
      erbs.each do |h|
        puts "key: #{h.key}"
      end
  
      erbs
    end
  
    def self._load erbs, filename
      is_erb = filename.end_with? ".erb"
      is_ignoring_ruby = !is_erb
      is_accepting_views = false
      
      puts
      puts "LERB filename: #{filename}"
      
      puts "LERB is_erb: #{is_erb}"
      puts "LERB is_ignoring_ruby: #{is_ignoring_ruby}"
      puts "LERB is_accepting_views: #{is_accepting_views}"
  
      current_lineno = 0
      current_content = ""
      current_key = is_erb ? filename.split("/").last : DEFAULT_KEY
  
      if current_key
        puts "LERB declare: #{current_key} | because not erb"
      end
  
      File.readlines(filename).each.with_index do |line, lineno|
        is_line_end = line == "__END__\n"
  
        # stop ignoring ruby lines if line is __END__
        # move to next line if ignoring ruby lines
  
        if is_ignoring_ruby
          puts "LERB ignore: #{lineno}: #{line[0..-2]}"
          if is_line_end
            is_ignoring_ruby = false
            is_accepting_views = true
            current_lineno = lineno + 1
            puts "LERB declare: #{current_key} | current" if current_key
          end
          next
        end
  
        if is_accepting_views && line[0..6] == "# view "
          _load_into erbs, filename, current_lineno, current_key, current_content
          current_key = line[7..-1].strip
          current_lineno = lineno + 1
          current_content = ""
          puts "LERB declare: #{current_key} | #{lineno}: #{line[0..-2]}"
        else
          current_content += line
          puts "LERB keeping: #{lineno}: #{line[0..-2]}"
        end
  
        if is_line_end
          puts "LERB warning: #{lineno}: #{line[0..-2]} found! No longer accepting views"
          is_accepting_views = false
        end
      end
  
      _load_into erbs, filename, current_lineno, current_key, current_content
  
      erbs
    end
  
    def self._load_into erbs, filename, lineno, key, content
      return unless key
      return unless key.end_with? "erb"
      return if content.strip.empty?
  
      content += "\n" if content[-1] != "\n"
  
      erbs.push new filename, lineno, key, content
    end
  
    # format
  
    TAG_FORMATS = %w|xml html|
  
    def tags?
      TAG_FORMATS.include? format
    end
  
    # constructor
  
    TRIM_MODE = "<>-"
  
    attr_reader :key, :name, :format
  
    def initialize filename, lineno, key, content
      segments = key.split("/").last.split(".")
      name, format = segments[0..1]
  
      if format.gsub(/[^a-z0-9]/, "") != format
        raise BuildError, "key '#{key}' has an invalid format '#{format}'"
      end
  
      super content, trim_mode: TRIM_MODE
      self.filename, self.lineno, @key, @name, @format = filename, lineno, key, name, format
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
  

end
