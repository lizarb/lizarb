class Liza::Box < Liza::Unit
  inherited_explicitly_sets_system

  # def self.has_panel symbol, panel_name = symbol
  #   system_klass = get :system
  #   panel_class = system_klass.const "#{symbol}_panel"

  #   _has_panel_define panel_name, "get(:panels)[:#{panel_name}]"

  #   panel = panel_class.new panel_name
  #   add :panels, panel_name, panel

  #   panel_class.on_connected self
  # end

  # def self.has_controller symbol, panel_name = symbol
  #   system_klass = get :system
  #   controller_class = system_klass.const symbol

  #   panel = public_send panel_name

  #   controller_class.on_connected self, panel
  # end

  # def self.method_missing symbol, *args, &block
  #   if panels.has_key? symbol
  #     panels[symbol]
  #   else
  #     super
  #   end
  # end

  # def self.respond_to_missing? symbol, include_private = false
  #   get(:panels).keys.include?(symbol) || super
  # end

#     def self._has_panel_define name, resource
#       class_eval <<-CODE, __FILE__, __LINE__ + 1

# def self.#{name} &block
#   if block_given?
#     #{resource}.instance_eval &block
#   else
#     #{resource}
#   end
# end

#       CODE
#     end

  def self.panels
    get :panels
  end

  def self.[] symbol
    panels[symbol].started
  end

  def self.panel symbol, panel_class = nil, &block
    raise ArgumentError, "block required" unless block_given?

    system_class = get :system
    panel_class ||= system_class.const "#{symbol}_panel"

    if Hash(get :panels).has_key? symbol
      panel = panels[symbol]
    else
      panel_class.on_connected self
      panel = panel_class.new symbol
      add :panels, symbol, panel
    end

    panel.push block
  end

  def self.has_controller symbol, panel_name = symbol
    system_klass = get :system
    controller_class = system_klass.const symbol

    panel = self[panel_name]

    controller_class.on_connected self, panel
  end

end
