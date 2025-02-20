class DevSystem::SignalShell < DevSystem::Shell

  # {"EXIT"=>0, "INT"=>2, "ILL"=>4, ...}
  def self.list
    ::Signal.list.sort_by { _2 }.to_h
  end

  def self.trap(signal, &block)
    Trap.find(signal).push block

    true
  end

  def self.traps() = @traps ||= {}

  def self.trap_interrupt(&block)
    trap("INT", &block)
  end

  def self.trap_kill(&block)
    trap("KILL", &block)
  end

  class Trap
    
    def self.find(signal)
      @traps ||= {}
      @traps[signal] ||= new(signal)
    end

    def initialize(signal)
      @blocks = []
      ::Signal.trap(signal) do
        puts "\nSignal.trap(#{signal.inspect})"
        puts "# Control-C pressed. #{@blocks.count} blocks to run..." if signal == "INT"
        call
        if signal == "INT"
          puts "# Exiting with status 1..."
          exit 1
        end
      end
    end

    def push (block) = @blocks.push block

    def call
      @blocks.each do |block|
        block.call
      end
    end
  end

end
