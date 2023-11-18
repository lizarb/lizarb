class WebSystem::RequestGenerator < DevSystem::SimpleGenerator

  # liza g request name place=app

  def call_default
    call_simple
  end

  # liza g request:simple name place=app
  
  def call_simple
    @controller_class = Request

    name!
    place!

    @args = Array command.simple_args[1..-1]

    @args = ["index"] if @args.empty?

    ancestor = SimpleRequest
    create_controller @name, @controller_class, @place, @path, ancestor: ancestor do |unit, test|
      unit.section :controller_section_1
      @args.each do |arg|
        unit.view  :controller_view_1, key: arg, format: :html
      end
      test.section :controller_test_section_1, caption: ""
    end
  end

  # liza g request:raw name place=app

  def call_raw
    @controller_class = Request

    name!
    place!

    @args = Array command.simple_args[1..-1]

    create_controller @name, @controller_class, @place, @path do |unit, test|
      unit.section :controller_section_raw_1, caption: ""
      test.section :controller_test_section_1, caption: ""
    end
  end

end

__END__

# view controller_section_1.rb.erb
<% @args.each do |arg|
  route = arg == "index" ? "/#{@name}" : "/#{@name}/#{arg}"
%>
  # GET <%= route %>

  def call_<%= arg %>
    log "."
  end

  # POST <%= route %>

  # def call_<%= arg %>!
  #   log "."
  # end
<% end -%>
# view controller_view_1.html.erb
<h1><%%= self.class %></h1>
<h2><%%= action %></h2>
<p>request: <%%= request %></p>
<p>action: <%%= action %></p>
<p>format: <%%= format %></p>
<p>http_method: <%%= http_method %></p>
<p>qs: <%%= qs %></p>
<p>segments: <%%= segments %></p>

# view controller_section_raw_1.rb.erb

  def self.call(env)
    path = env["REQUEST_PATH"]

    status = 200
    headers = {
      "Framework" => "Liza \#{Lizarb::VERSION}"
    }
    body = "It works! <%= @name.camelize %>Request"

    [status, headers, [body]]
  end

# view controller_test_section_1.rb.erb

  test :subject_class, :subject do
    assert_equality <%= @class_name %>, subject_class
    assert_equality <%= @class_name %>, subject.class
  end
