class DevSystem::FormatterGenerator < DevSystem::Generator

  #

  division!

  #

  def self.call args
    log "args = #{args.inspect}" if DevBox[:generator].get :log_details
  end

end
