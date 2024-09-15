class Liza::Box < Liza::Unit

  def self.panels
    fetch(:panels) { {} }
  end

  def self.[] symbol
    panels[symbol].started
  end

  def self.configure name, &block
    raise ArgumentError, "block required" unless block_given?
    raise ArgumentError, "Invalid panel: #{name}. Valid panels are: #{system.subs}" unless system.subs.include? name

    panel = panels[name] ||= Liza.const("#{name}_panel").new name
    panel.push block
  end

  def self.forward panel_key, method_name=nil
    case method_name
    when NilClass
      method_name = :call
      box_method_name = panel_key
    when Symbol
      box_method_name = method_name
    when Hash
      box_method_name = method_name.keys.first
      method_name = method_name.values.first
    else
      raise ArgumentError, "Invalid method_name: #{method_name.inspect}. Expecting Symbol or Hash."
    end
    
    define_singleton_method box_method_name do |*args, **kwargs|
      self[panel_key].send method_name, *args, **kwargs
    end
  end

  def self.color
    system.color
  end
end

__END__

# view default.rb.erb
<% token = system.token.to_s.capitalize -%>
class <%= token %>Box < <%= token %>System::<%= token %>Box

end
