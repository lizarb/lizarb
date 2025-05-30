class DevSystem::KernelShell < DevSystem::Shell
  
  # 

  def self.call_backticks(command, log_level: :normal)
    t = Time.now
    log log_level, "#{stick command, DevSystem.color} | returns a string | executing..."
    result = Kernel.send :`, command
  ensure
    log log_level, "#{t.diff}s | executed with an output of #{"#{result.size} bytes" if result}#{result.inspect unless result} |"
    puts result if log? log_level
  end

  #

  def self.call_system(command, log_level: :normal)
    t = Time.now
    log log_level, "#{command} | returns a boolean | executing..."
    success = Kernel.system(command)
    success
  ensure
    message = success ? (stick :green, "successfully") : (stick :red, "failed")
    log log_level, "#{t.diff}s | #{message}"
  end

end
