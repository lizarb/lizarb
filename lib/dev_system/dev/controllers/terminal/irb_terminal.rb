class DevSystem
  class IrbTerminal < Terminal

    def self.call args
      log :higher, "Called #{self}.#{__method__} with args #{args}"

      # https://github.com/ruby/ruby/blob/master/lib/irb.rb
      require "irb"

      IRB.setup(nil)
      workspace = IRB::WorkSpace.new(binding)
      irb = IRB::Irb.new(workspace)
      IRB.conf[:MAIN_CONTEXT] = irb.context

      irb.eval_input
    end

  end
end
