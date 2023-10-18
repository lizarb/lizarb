class Liza::Unit

  # ERROR
  
  class Error < Liza::Error; end

  # PART

  def self.part key, klass = nil, system: nil
    Lizarb.connect_part self, key, klass, system
  end

  # CONST MISSING

  if Lizarb.ruby_supports_raise_cause?

    def self.const_missing name
      Liza.const name
    rescue Liza::ConstNotFound
      raise NameError, "uninitialized constant #{name}", caller[1..], cause: nil
    end

  else

    def self.const_missing name
      Liza.const name
    rescue Liza::ConstNotFound
      raise NameError, "uninitialized constant #{name}", caller[1..]
    end

  end

  # PARTS

  part :unit_classes

  part :unit_logging

  part :unit_methods

  part :unit_procedure
  
  class RenderError < Error; end
  class RendererNotFound < RenderError; end
  class RenderStackIsFull < RenderError; end
  class RenderStackIsEmpty < RenderError; end
  part :unit_renderer

  part :unit_settings

  # TEST

  def self.test_class
    @test_class ||=
      if first_namespace == "Liza"
        Liza.const_get "#{last_namespace}Test"
      else
        Object.const_get "#{name}Test"
      end
  end

  # SYSTEM

  def self.system
    if name&.include? "::"
      return System if first_namespace == "Liza"
      Object.const_get first_namespace
    else
      superclass.system
    end
  end

  singleton_class.send :public, :system

  def system
    self.class.system
  end

  public :system

end

__END__

# view render.txt.erb
<%= render if render_stack.any? -%>
