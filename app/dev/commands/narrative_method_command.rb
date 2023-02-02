class NarrativeMethodCommand < Liza::Command
  class Error < StandardError; end
  class Invalid < Error; end

  def self.call(args)
    log "Called #{self}.#{__method__} with args #{args}"
    new.call(args)
  end

  # instance methods

  def call(args)
    log "Called #{self}.#{__method__} with args #{args}"
    return help if args.empty?

    @args = args
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
    log "Called #{self}.#{__method__}"
    log render "error.txt"
  end

  def help
    log "Called #{self}.#{__method__}"
    log render "help.txt"
  end
end

__END__

# success.txt.erb

RESULT:

class      <%= @result.class %>
value      <%= @result %>

# error.txt.erb

ERROR:

class      <%= @error.class %>
message    <%= @error.message %>
backtrace  <%= @error.backtrace.select { |s| @stop = true if s.include?("/exe/lizarb:"); !defined? @stop }.join "\n           " %>
