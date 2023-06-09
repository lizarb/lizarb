class DevSystem::FormatterGenerator < DevSystem::Generator

  def self.call args
    log "args = #{args.inspect}" if DevBox[:generator].get :log_details
  end

end
