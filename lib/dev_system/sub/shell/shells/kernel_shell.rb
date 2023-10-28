class DevSystem::KernelShell < DevSystem::Shell
  
  # 

  def self.call_backticks(command)
    log "#{command} | executing #{"and outputting result" if log? :lower}"
    result = `#{command}`
    puts result if log? :lower
    result
  end

  #

  def self.call_system(command)
    log "#{command} | executing"
    success = Kernel.system(command)
    message = success ? (stick :green, "successfully") : (stick :red, "failed")
    log "Command executed #{message}"
    success
  end

end
