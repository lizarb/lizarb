class DevSystem::FormatterGenerator < DevSystem::Generator

  #

  division!

  #

  def self.call args
    log :lower, "args = #{args.inspect}"
  end

end
