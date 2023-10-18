class DevSystem::ConverterGenerator < DevSystem::Generator

  #

  division!

  #

  def self.call args
    log :lower, "args = #{args.inspect}"
  end

end
