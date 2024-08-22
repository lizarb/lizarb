class NarrativeMethodCommand < DevSystem::SimpleCommand
  class Error < StandardError; end
  class Invalid < Error; end

  def call_default
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
    log render(:error, format: :txt)
  end

  def help
    log render(:help, format: :txt)
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
