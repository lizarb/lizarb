class Liza::Unit

  # ERROR
  
  class Error < Liza::Error; end

  # PART

  def self.part key, klass = nil, system: nil
    part_class ||= if system.nil?
                Liza.const "#{key}_part"
              else
                Liza.const("#{system}_system")
                    .const "#{key}_part"
              end
    self.class_exec(&part_class.insertion) if part_class.insertion
  end

  # CONST MISSING

  def self.const_missing name
    Liza.const name
  rescue Liza::ConstNotFound
    if Lizarb.ruby_supports_raise_cause?
      raise NameError, "uninitialized constant #{name}", caller[1..], cause: nil
    else
      raise NameError, "uninitialized constant #{name}", caller
    end
  end

  # PARTS

  part :unit_associating

  part :unit_logging

  part :unit_methods

  class RenderError < Error; end
  class RendererNotFound < RenderError; end
  class RenderStackIsFull < RenderError; end
  class RenderStackIsEmpty < RenderError; end
  part :unit_renderer

  part :unit_setting

  def self.reload!
    Lizarb.reload
  end

  def reload!
    Lizarb.reload
  end

  #

  set :log_level, App.log_level
  set :division, Liza::Controller
  
end

__END__

# view render.txt.erb
<%= render if render_stack.any? -%>
