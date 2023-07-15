class WebSystem::RequestCommand < Liza::Command

  def self.call(args)
    log "args = #{args.inspect}"
    path = args.first

    help(args) # always show help

    new.instance_exec do
      @env = {}
      @env["REQUEST_PATH"] = path

      request_panel.find @env

      @request_class = @env["LIZA_REQUEST_CLASS"] || raise("No request class found")

      puts render :find, format: :txt
    end
  end

  def self.help(args)
    log "args = #{args.inspect}"
    new.instance_exec do
      puts render :help, format: :txt
    end
  end

  def self.get(args)
    return superclass.method(__method__).call(args) unless args.is_a? Array
    log "args = #{args.inspect}"
    path = args.first
    return help if path.nil?
    
    new.instance_exec do
      @env = {}
      @env["REQUEST_METHOD"] = "GET"
      @env["REQUEST_PATH"]   = path

      @status, @headers, @body = request_panel.call @env
      log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
      puts render :response, format: :http
    end
  end

  def self.post(args)
    return superclass.method(__method__).call(args) unless args.is_a? Array
    log "args = #{args.inspect}"
    path = args.first
    return help if path.nil?
    
    new.instance_exec do
      @env = {}
      @env["REQUEST_METHOD"] = "POST"
      @env["REQUEST_PATH"]   = path

      @status, @headers, @body = request_panel.call @env
      log "STATUS #{@status} with #{@headers.count} headers and a #{@body.first.size} byte body"
      puts render :response, format: :http
    end
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

liza request /path/to/action.format
liza request:get /path/to/action.format
liza request:post /path/to/action.format
liza request:help

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
