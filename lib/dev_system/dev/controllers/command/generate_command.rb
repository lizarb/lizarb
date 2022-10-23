class DevSystem
  class GenerateCommand < Command

    def self.call args
      # 1. LOG

      log :higher, "args: #{args}"
      puts

      # 2. FIND generator

      generator = args[0]

      log({generator:})

      generator_klass = Liza.const "#{generator}_generator"

      # 3. CALL

      generator_klass.call args[1..-1]
    end
  end
end
