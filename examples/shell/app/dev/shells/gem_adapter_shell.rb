class GemAdapterShell < DevSystem::Shell
  # class Error < Liza::Error; end
  # class CustomError < Error; end

  # GemAdapterShell.do_something "some args"

  def self.do_something(args)
    log "args = #{args.inspect}"
    result = nil

    # require "some_gem"
    # result = SomeGem.do_something args
    result = [:some, :result]
    log "result = #{result.inspect}"
    
    result
  end

  # GemAdapterShell.do_something_else "some args"

  def self.do_something_else(args)
    log "args = #{args.inspect}"
    result = nil

    # require "some_gem"
    # result = SomeGem.do_something_else args
    result = {:some=>{:other=>:result}}
    log "result = #{result.inspect}"
    
    result
  end

end
