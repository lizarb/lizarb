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

  # color

  def self.color
    system.color
  end
end

__END__

# view default.rb.erb
<% token = system.token.to_s.capitalize -%>
class <%= token %>Box < <%= token %>System::<%= token %>Box

end
