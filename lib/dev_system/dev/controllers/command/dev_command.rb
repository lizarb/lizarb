class DevSystem
  class DevCommand < Command

    def self.call args
      if args[0] == "pry"
        require "pry"
        Pry.start
      else
        log :higher, "Called #{self} with args #{args}"

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
end
