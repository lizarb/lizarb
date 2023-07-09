class Liza::Box < Liza::Unit
  inherited_explicitly_sets_system

  def self.panels
    fetch(:panels) { {} }
  end

  def self.[] symbol
    panels[symbol].started
  end

  def self.configure name, &block
    _has_panel name, &block
    _has_controller name, name
  end

  def self._has_panel symbol, panel_class = nil, &block
    raise ArgumentError, "block required" unless block_given?

    system_class = get :system
    panel_class ||= system_class.const "#{symbol}_panel"

    if panels.has_key? symbol
      panel = panels[symbol]
    else
      panel_class.on_connected self
      panel = panel_class.new symbol
      add :panels, symbol, panel
    end

    panel.push block
  end

  def self._has_controller symbol, panel_name = symbol
    system_klass = get :system
    controller_class = system_klass.const symbol

    panel = self[panel_name]

    controller_class.on_connected self, panel
  end

end
