class Liza::Box < Liza::Unit

  def self.panels
    fetch(:panels) { {} }
  end

  def self.controllers
    @controllers ||= {}
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

    panel_class ||= system.const "#{symbol}_panel"

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
    controller_class = system.const symbol
    self.controllers[symbol] = controller_class

    panel = self[panel_name]

    controller_class.on_connected self, panel
  end

end
