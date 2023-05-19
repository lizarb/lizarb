class DevSystem::IrbTerminal < DevSystem::Terminal

  def self.call args
    log "args = #{args.inspect}"

    # https://github.com/ruby/ruby/blob/master/lib/irb.rb
    require "irb"

    IRB.setup(nil)
    workspace = IRB::WorkSpace.new(binding)
    irb = IRB::Irb.new(workspace)
    IRB.conf[:MAIN_CONTEXT] = irb.context

    def irb.signal_status(status)
      super
    rescue Interrupt
      IrbTerminal.log "Control-C"
    end

    irb.eval_input
  end

end
