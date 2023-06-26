class WebSystem::RequestCommand < Liza::Command

  VALID_ACTIONS = %w[find get post]

  def call(args)
    log "args = #{args.inspect}"

    @command = args.shift
    @args = args
    
    return help unless VALID_ACTIONS.include? @command
    perform
  rescue StandardError => error
    @error = error
    handle
  end

  def perform
    case @command
    when "find"
      find
    when "get"
      get_request
    when "post"
      post_request
    end
  end

  def handle
    log render_controller "error.txt"
  end

  def help
    log render_controller "help.txt"
  end

  # actions

  def find
    path = @args.first

    @env = {}
    @env["REQUEST_PATH"] = path

    request_panel.find @env

    @request_class = @env["LIZA_REQUEST_CLASS"] || raise("No request class found")

    puts render_controller "find.txt"
  end

  def get_request
    path = @args.first
    
    @env = {}
    @env["REQUEST_METHOD"] = "GET"
    @env["REQUEST_PATH"]   = path

    @status, @headers, @body = request_panel.call @env
    log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
    puts render_controller "response.http"
  end

  def post_request
    path = @args.first
    
    @env = {}
    @env["REQUEST_METHOD"] = "POST"
    @env["REQUEST_PATH"]   = path

    @status, @headers, @body = request_panel.call @env
    log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
    puts render_controller "response.http"
  end

  # helpers

  def request_panel
    @request_panel ||= WebBox[:request]
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

# view help.txt.erb

USAGE:

liza request find /path/to/action.format
liza request get /path/to/action.format
liza request post /path/to/action.format

# view find.txt.erb

ENV:
<% @env.each do |k, v| %>
env["<%= k %>"] = <%= v.inspect -%>
<% end %>

REQUEST CLASS:

# <%= @request_class.source_location.join ":" %>
class <%= @request_class %> < <%= @request_class.superclass %>
  # ...
end

# view response.http.erb

<%= @status %>
<% @headers.each do |k, v| -%>
<%= k %>: <%= v %>
<% end -%>

<%= @body.first %>
