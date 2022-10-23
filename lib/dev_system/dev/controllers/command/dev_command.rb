class DevSystem
  class DevCommand < Command

    def self.call args
      # 1. LOG

      log :higher, "args: #{args}"
      puts

      # 2. FIND terminal

      terminal = args[0] || "irb"

      log({terminal:})

      terminal_klass = Liza.const "#{terminal}_terminal"

      # 3. CALL

      terminal_klass.call Array(args[1..-1])
    end

  end
end
