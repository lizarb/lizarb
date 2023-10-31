class LabSystem::KrokiRequest < WebSystem::SimpleRequest

  def call_index
    @table = []

    @table << KrokiClient.new_plantuml(:ab, :svg)
    @table << KrokiClient.new_nomnoml(:ab, :svg)

    @table.map &:call
  end
  
  #

  def call_plantuml
    @table = []
    
    @table << KrokiClient.new_plantuml(:ab, :svg)

    @table.map &:call
  end
  
  #

  def call_nomnoml
    @table = []

    @table << KrokiClient.new_nomnoml(:ab, :svg)

    @table.map &:call
  end
  
  #
  
  def call_plantuml_liza
    @table = []

    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = Unit.subclasses.sort { _1.name <=> _2.name }.reverse
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Liza::System]
      @systems_in_objects = [DevSystem, NetSystem, WebSystem]
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Liza::System]
      @systems_in_objects = [HappySystem, LabSystem]
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Liza::System]
      @systems_in_objects = [DevSystem, NetSystem, WebSystem, WorkSystem, MicroSystem, DeskSystem]
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Liza::System]
      @systems_in_objects = App.systems.values
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Box]
      @boxes = [DevBox]
      @subs = []
      @objects = []
      @systems = (@boxes+@subs+@objects).map(&:system).uniq
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Box]
      @boxes = [DevBox, NetBox, WebBox, WorkBox]
      @subs = []
      @objects = []
      @systems = (@boxes+@subs+@objects).map(&:system).uniq
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Panel, Controller]
      @subs = [Command, Shell]
      @objects = []
      @systems = (@subs+@objects).map(&:system).uniq
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Panel, Controller]
      @subs = [Command]
      @objects = [BestCommand]
      @systems = (@subs+@objects).map(&:system).uniq
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Panel, Controller]
      @subs = [Command]
      @objects = [DockerCommand, BestCommand, LabSystem::DockerCommand]
      @systems = (@subs+@objects).map(&:system).uniq
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = [Command, DockerCommand, BestCommand, LabSystem::DockerCommand]
      @systems = (@subs+@objects).map(&:system).uniq
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = [Command, Shell, LabSystem::DockerCommand, DockerCommand, DockerShell]
      @systems = (@subs+@objects).map(&:system).uniq
    }
    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = App.systems.values.map { _1.box.panels.values.map(&:division) }.flatten
      @systems = (@subs+@objects).map(&:system).uniq
    }

    # NetSystem

    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = [Command, Database, Client, DatabaseCommand, *Database.descendants, *Client.descendants]
      @systems = (@subs+@objects).map(&:system).uniq
    }

    # WebSystem

    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = [Command, WebSystem::Rack]
      @objects = [RackCommand, MiddleRack, ServerRack, *MiddleRack.subclasses, *ServerRack.subclasses]
      @systems = (@subs+@objects).map(&:system).uniq
    }

    @table << LizaKrokiClient.new_plantuml(:liza_1, :svg) {
      @units = [Controller]
      @subs = []
      @objects = [Command, Request, RequestCommand, *Request.descendants]
      @systems = (@subs+@objects).map(&:system).uniq
    }

    @table.map &:call
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

<% @table.each do |kroki| %>
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
