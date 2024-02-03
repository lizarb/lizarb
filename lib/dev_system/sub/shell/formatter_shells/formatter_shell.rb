class DevSystem::FormatterShell < DevSystem::Shell

  #

  division!

  #

  def self.call args
    log :higher, "args = #{args.inspect}"
  end

end
