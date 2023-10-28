class DevSystem::IrbCommand < DevSystem::Command

  def self.call args
    log "args = #{args.inspect}"

    # https://github.com/ruby/ruby/blob/master/lib/irb.rb
    require "irb"

    IRB.setup(nil)
    workspace = IRB::WorkSpace.new(binding)
    irb = IRB::Irb.new(workspace)
    IRB.conf[:MAIN_CONTEXT] = irb.context

    irb.eval_input
  rescue Interrupt
    log "Control-C"
  end

end
