class WebSystem::RequestCommand < DevSystem::SimpleCommand

  def call_default
    log "args = #{args.inspect}"
    path, qs = args.first.split("?")

    help # always show help

    @request_env = {}
    @request_env["PATH_INFO"] = path
    @request_env["QUERY_STRING"] = qs
    request_panel.find @request_env
    @request_class = @request_env["LIZA_REQUEST_CLASS"] || raise("No request class found")

    puts render :find, format: :txt
  end

  def help
    log "args = #{args.inspect}"
    puts render :help, format: :txt
  end

  def call_get
    return superclass.method(__method__).call(args) unless args.is_a? Array
    log "args = #{args.inspect}"
    path, qs = args.first.split("?")
    return help if path.nil?
    
    @request_env = {}
    @request_env["REQUEST_METHOD"] = "GET"
    @request_env["PATH_INFO"]   = path
    @request_env["QUERY_STRING"] = qs

    @status, @headers, @body = request_panel.call! @request_env
    log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
    puts render :response, format: :http
  end

  def call_post
    return superclass.method(__method__).call(args) unless args.is_a? Array
    log "args = #{args.inspect}"
    path, qs = args.first.split("?")
    return help if path.nil?
    
    @request_env = {}
    @request_env["REQUEST_METHOD"] = "POST"
    @request_env["PATH_INFO"]   = path
    @request_env["QUERY_STRING"] = qs

    @status, @headers, @body = request_panel.call! @request_env
    log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
    puts render :response, format: :http
  end

  # helpers

  def request_panel
    @request_panel ||= WebBox[:request]
  end
  
  # TODO: fix this
  def self.call_get_command_sign
    super << {name: "get", description: "# no description"}
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

liza request /path/to/action.format
liza request:get /path/to/action.format
liza request:post /path/to/action.format
liza request:help

# view find.txt.erb

ENV:
<% @request_env.each do |k, v| %>
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
