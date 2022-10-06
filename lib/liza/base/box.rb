module Liza
  class Box < Unit
    inherited_explicitly_sets_system

    def self.has_panel symbol, panel_name = symbol
      system_klass = get :system
      panel_class = system_klass.const "#{symbol}_panel"

      _has_panel_define panel_name, "get(:panels)[:#{panel_name}]"

      panel = panel_class.new panel_name
      add :panels, panel_name, panel

      panel_class.on_connected self
    end

    def self.has_controller symbol, panel_name = symbol
      system_klass = get :system
      controller_class = system_klass.const symbol

      panel = public_send panel_name

      controller_class.on_connected self, panel
    end

    def self._has_panel_define name, resource
      class_eval <<-CODE, __FILE__, __LINE__ + 1

def self.#{name} &block
  if block_given?
    #{resource}.instance_eval &block
  else
    #{resource}
  end
end

      CODE
    end
  end
end
