class Liza::Box < Liza::Unit

  def self.panels
    fetch(:panels) { {} }
  end

  def self.[] symbol
    configuration.panels[symbol].started
  end

  section :two_boxes

  # Returns the Preconfiguration Box.
  # (The Box in the systems directory)
  # DevSystem::DevBox, HappySystem::HappyBox, etc.
  # @return [Liza::Box]
  def self.preconfiguration
    @preconfiguration ||= last_namespace == name ? self.superclass : self
  end

  # Returns the Configuration Box.
  # (The Box in the app directory)
  # DevBox, HappyBox, etc.
  # @return [Liza::Box]
  def self.configuration
    @configuration ||= begin
      last_namespace == name ? self : const_get(last_namespace)
    rescue NameError
      self
    end
  end

  # Preconfigure from the Preconfiguration Box at lib/my_system/my_box.rb
  # @param name [Symbol]
  # @param block [Proc] This block will only be loaded when configuration is requested.
  def self.preconfigure(name, &block)= configure(name, &block)

  # Configure from the Configuration Box at app/my_box.rb
  # @param name [Symbol]
  # @param block [Proc] This block will only be loaded when configuration is requested.
  def self.configure name, &block
    raise ArgumentError, "block required" unless block_given?
    raise ArgumentError, "Invalid panel: #{name}. Valid panels are: #{system.subs}" unless system.subs.include? name

    panel = panels[name] ||= Liza.const("#{name}_panel").new name
    panel.push block
  end

  section :forwarding

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
