class BashAdapterShell < DevSystem::Shell
  # class Error < Liza::Error; end
  # class CustomError < Error; end

  def self.query_something(args)
    log "args = #{args.inspect}"
    output = nil

    output = KernelShell.call_backticks("echo '#{args.size}'")
    log "output = #{output.inspect}"
    
    output
  end

  def self.execute_something(args)
    log "args = #{args.inspect}"
    it_worked = nil

    it_worked = KernelShell.call_system("echo '#{args.size}'")
    log "it_worked = #{it_worked.inspect}"
    
    it_worked
  end

end
