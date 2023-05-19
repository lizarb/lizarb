class NarrativeMethodCommand < Liza::Command
  class Error < StandardError; end
  class Invalid < Error; end

  def self.call(args)
    log "args = #{args.inspect}"
    new.call(args)
  end

  # instance methods

  def call(args)
    @args = args
    log "@args = #{args.inspect}"
    return help if args.empty?

    validate
    perform
  rescue StandardError => error
    @error = error
    handle
  ensure
    @result
  end

  def validate
    raise NotImplementedError
  end

  def perform
    raise NotImplementedError
  end

  def handle
    log render "error.txt"
  end

  def help
    log render "help.txt"
  end
end

__END__

# view success.txt.erb

RESULT:

class      <%= @result.class %>
value      <%= @result %>

# view error.txt.erb

ERROR:

class      <%= @error.class %>
message    <%= @error.message %>
backtrace  <%= @error.backtrace.select { |s| @stop = true if s.include?("/exe/lizarb:"); !defined? @stop }.join "\n           " %>
