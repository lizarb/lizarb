class DevSystem::BaseCommand < DevSystem::Command

  #

  def self.call(env)
    log :lower, "env.count is #{env.count}"
    
    command = env[:command] = new
    command.call env
  end

  #

  attr_reader :env

  def call(env)
    log :lower, "env.count is #{env.count}"
    @env = env
    
    method_name = env[:command_arg]
    method_name = method_name.split(":")[1] || :default
    method_name = "call_#{method_name}"
    return public_send method_name if respond_to? method_name

    log "method not found: #{method_name.inspect}"
    raise NoMethodError, "method not found: #{method_name.inspect}"
  end

end
