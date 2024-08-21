class DevSystem::IrbCommand < DevSystem::SimpleCommand
  # https://github.com/ruby/ruby/blob/master/lib/irb.rb
  require "irb"

  # liza irb
  def call_default
    IRB.setup(nil)
    workspace = IRB::WorkSpace.new(binding)
    irb = IRB::Irb.new(workspace)
    IRB.conf[:MAIN_CONTEXT] = irb.context

    irb.eval_input
  rescue Interrupt
    log "Control-C"
  end

end
