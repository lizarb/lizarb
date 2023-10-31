class LabSystem::KrokiRequest < WebSystem::SimpleRequest

  def call_index
    @kroki_clients = []

    @kroki_clients << KrokiClient.new_plantuml(:ab, :svg)
    @kroki_clients << KrokiClient.new_nomnoml(:ab, :svg)

    @kroki_clients.map &:call
  end
  
  #

  def call_plantuml
    @kroki_clients = []
    
    @kroki_clients << KrokiClient.new_plantuml(:ab, :svg)

    @kroki_clients.map &:call
  end
  
  #

  def call_nomnoml
    @kroki_clients = []

    @kroki_clients << KrokiClient.new_nomnoml(:ab, :svg)

    @kroki_clients.map &:call
  end
  
  #
  
  def call_plantuml_liza
    @kroki_clients = []

    Lizarb.loaders.map &:eager_load

    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = Unit.subclasses.sort { _1.name <=> _2.name }.reverse
    }
    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Liza::System]
      @systems_in_objects = [DevSystem, NetSystem, WebSystem]
    }
    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Liza::System]
      @systems_in_objects = [HappySystem, LabSystem]
    }
    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Liza::System]
      @systems_in_objects = App.systems.values
    }
    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Box]
      @boxes = [DevBox]
      @subs = []
      @objects = []
      @systems = (@boxes+@subs+@objects).map(&:system).uniq
    }
    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Box]
      @boxes = [DevBox, NetBox, WebBox]
      @subs = []
      @objects = []
      @systems = (@boxes+@subs+@objects).map(&:system).uniq
    }
    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Panel, Controller]
      @subs = [Command, Shell]
      @objects = []
      @systems = (@subs+@objects).map(&:system).uniq
    }
    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = App.systems.values.map { _1.box.panels.values.map(&:division) }.flatten
      @systems = (@subs+@objects).map(&:system).uniq
    }

    # NetSystem

    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = [Command, Database, Client, DatabaseCommand, *Database.descendants, *Client.descendants]
      @systems = (@subs+@objects).map(&:system).uniq
    }

    # WebSystem

    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = [Command, WebSystem::Rack]
      @objects = [RackCommand, MiddleRack, ServerRack, *MiddleRack.subclasses, *ServerRack.subclasses]
      @systems = (@subs+@objects).map(&:system).uniq
    }

    @kroki_clients << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = [Command, Request, RequestCommand, *Request.descendants]
      @systems = (@subs+@objects).map(&:system).uniq
    }

    @kroki_clients.map &:call
  end

end

__END__

# view index.html.erb
<%= render :shared %>

# view plantuml.html.erb
<%= render :shared %>

# view plantuml_liza.html.erb
<%= render :shared %>

# view nomnoml.html.erb
<%= render :shared %>

# view shared.html.erb
<%= render :header %>

<style>
td {
  border: 1px dashed black;
  vertical-align: top;
}
td svg {
  text-align: center;
}
td code {
  text-align: left;
}
</style>

<h3>plantuml</h3>

<table>
<tr>
  <td>
    template
  </td>
  <td>
    code
  </td>
  <td>
    SVG
  </td>
</tr>

<% @kroki_clients.each do |kroki| %>
<tr>
  <td>
    <%= kroki.action %>
  </td>
  <td style="min-width: 700px">
    <code>
    <%= kroki.code.gsub "\n", "<br/>" %>
    </code>
  </td>
  <td>
    <%= kroki.result %>
  </td>
</tr>
<% end %>

</table>

# view header.html.erb

<h1>KrokiClient</h1>
<a href="/kroki">/kroki</a> |

<a href="/kroki/plantuml">/kroki/plantuml</a> |
<a href="/kroki/plantuml_liza">/kroki/plantuml_liza</a> |
<a href="/kroki/nomnoml">/kroki/nomnoml</a>
<hr/>
