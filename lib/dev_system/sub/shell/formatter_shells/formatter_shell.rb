class DevSystem::FormatterShell < DevSystem::Shell

  #

  division!

  #

  def self.call args
    log :lower, "args = #{args.inspect}"
  end

end
