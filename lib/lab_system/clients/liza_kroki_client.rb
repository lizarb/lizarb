class LabSystem::LizaKrokiClient < LabSystem::LabKrokiClient

  def puml
    @puml ||= PlantumlHelper.new
  end

  class PlantumlHelper
    def unit_type_for klass
      case klass.last_namespace
      when "Test"
        "safety"
      when "Box", "Part", "System"
        "meta"
      when "Panel", "Controller"
        "base"
      else
        "other"
      end
    end

    def name_for klass
      return "Liza.Unit" if klass == Liza::Unit
      if klass.first_namespace == "Liza"
        return "Liza.#{unit_type_for klass}.#{klass.last_namespace}"
      end

      klass = "Object::#{klass}" unless klass.to_s.include? "::"
      klass.to_s.gsub "::", "."
    end

    def package_object
      "package Object #ffffff;text:000000;line.bold;line:black"
    end

    def package_system_in_object system, color
      "package #{ name_for system } #{ color };line.bold;line:black;text:black"
    end

    def package_system system, color
      "package #{ system } #{ color };line.bold;line:black;text:black"
    end

    def package_box box, color
      %|node #{ name_for box } as "#{ box.last_namespace }" #{ color };line.bold;line:black;text:black|
    end

    def rectangle_unit_type unit_type
      %|rectangle Liza.#{ unit_type } as "#{ unit_type } units" #ffffff;text:000000;line.bold;line:black|
    end

    def inheritance klass
      association klass.superclass, klass, "<|-down--"
    end

    def association a, b, arrow
      %(#{ name_for a } #{arrow} #{ name_for b })
    end
  end

end

__END__

# view liza_1.plantuml.erb

@startuml
top to bottom direction
skinparam groupInheritance 2

<style>
document {
  BackgroundColor white
}
package {
  
}
componentDiagram {
  
}
classDiagram {
  rectangle {
  }
  package {
  }
  node {
    FontStyle bold
  }
  hexagon {
    FontStyle bold
  }
  class {
      header {
        FontSize 14
        FontStyle bold
      }
  }
}
</style>

<%= render! :units %>
<%= render! :systems_in_objects %>
<%= render! :systems %>
<%= render! :boxes %>
<%= render! :subs %>
<%= render! :objects %>

@enduml

# view units.plantuml.erb
<% unit_types = @units.map { puml.unit_type_for _1 }.uniq -%>
'unit_type'
<% unit_types.each do |unit_type| -%>
<%= puml.rectangle_unit_type unit_type %> {
}
<% end -%>
'units'
<% @units.each do |unit| -%>
<%= puml.inheritance unit %>
<% end -%>

# view systems_in_objects.plantuml.erb
'systems in objects'
<% Array(@systems_in_objects).each do |system| -%>
<% color = ColorShell.parse_to_str system.color -%>
<%= puml.package_system_in_object system, color %> {
}
<% end.each do |system| -%>
<%= puml.inheritance system %>
<% end -%>

# view systems.plantuml.erb
'systems'
<% Array(@systems).each do |system| -%>
  <% color = ColorShell.parse_to_str system.color -%>
  <%= puml.package_system system, color %> {
  }
<% end -%>

# view boxes.plantuml.erb
'boxes'
<% Array(@boxes).each do |box| -%>
  <% color = ColorShell.parse_to_str box.system.color -%>
  <%= puml.package_box box.superclass, color %> {
  }
  <%= puml.package_box box, color %> {
  }
  <%= puml.inheritance box.superclass %>
  <%= puml.inheritance box %>
<% end -%>

# view subs.plantuml.erb
'subs'
<% Array(@subs).each do |controller| -%>
  <% color = ColorShell.parse_to_str controller.division.system.color -%>
  <% panel = controller.panel.class -%>
  <%= puml.inheritance panel %>
  <%= puml.inheritance controller %>

  hexagon <%= puml.name_for panel %> <%= color %>;text:000000;line.bold; {
  }
  class <%= puml.name_for controller %> <%= color %>;text:000000;line.bold; {
    a hierarchy of <%= controller.plural %>
  }
<% end -%>

# view objects.plantuml.erb
'objects'
<%= puml.package_object %> {
}
<% Array(@objects).each do |controller| -%>
  <% color = ColorShell.parse_to_str controller.division.system.color %>
  class <%= puml.name_for controller %> <%= color %>;text:000000;line.bold; {
    <%= "division #{controller.plural}" if controller.division? %>
  }
  <%= puml.inheritance controller %>
<% end -%>
