class FooRequest < WebSystem::SimpleRequest

  # GET /foo

  def call_index
    log "."
  end

  # POST /foo

  def call_index!
    log "."
  end

end

__END__

# view index.html.erb
<h1><%= self.class %></h1>
<h2><%= action %></h2>
<p>request: <%= request %></p>
<p>action: <%= action %></p>
<p>format: <%= format %></p>
<p>qs: <%= qs %></p>
<p>segments: <%= segments %></p>
