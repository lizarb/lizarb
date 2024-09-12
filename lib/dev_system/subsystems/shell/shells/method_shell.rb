class DevSystem::MethodShell < DevSystem::Shell
  class NotFoundError < Error; end

  #

  def self.signature_has_single_parameter_named?(object, method_name, arg_name)
    return false unless object.respond_to? method_name
    new(object, method_name).signature_has_single_parameter_named?(arg_name)
  end

  #

  attr_reader :object, :method_name

  def initialize(object, method_name)
    super()
    @object = object
    @method_name = method_name
    
    @method = object.method method_name
  rescue NameError
    raise NotFoundError, "method not found: #{method_name.inspect}", caller
  end

  #
  
  def method(sym=nil)
    return super if sym
    @method
  end

  #

  def line
    @line ||= File.readlines(@method.source_location[0])[@method.source_location[1] - 1].strip
  end

  def line_location
    @line_location ||= begin
      path = @method.source_location[0].gsub(App.root.to_s, "")[1..-1]
      line_number = @method.source_location[1]
      "#{path}:#{line_number}"
    end
  end

  #

  def signature_has_single_parameter_named?(name)
    @method.parameters == [[:req, name]]
  end

end
