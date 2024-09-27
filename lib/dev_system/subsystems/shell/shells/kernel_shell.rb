class DevSystem::KernelShell < DevSystem::Shell
  
  # 

  def self.call_backticks(command, log_level: :normal)
    log log_level, "#{stick command, DevSystem.color} | executing and outputting result"
    result = Kernel.send :`, command
    puts result if log? log_level
    result
  end

  #

  def self.call_system(command, log_level: :normal)
    log log_level, "#{command} | executing"
    success = Kernel.system(command)
    message = success ? (stick :green, "successfully") : (stick :red, "failed")
    log log_level, "Command executed #{message}"
    success
  end

end
