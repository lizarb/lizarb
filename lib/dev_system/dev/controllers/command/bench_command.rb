class DevSystem
  class BenchCommand < Command

    def self.call args
      # 1. LOG

      log :higher, "args: #{args}"
      puts

      # 2. FIND bench

      bench = args[0]

      log({bench:})

      bench_klass = Liza.const "#{bench}_bench"

      # 3. CALL

      bench_klass.call args[1..-1]
    end

  end
end
