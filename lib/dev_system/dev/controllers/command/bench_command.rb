class DevSystem::BenchCommand < DevSystem::Command

  def self.call args
    # 1. LOG

    log :higher, "args: #{args}"
    puts

    # 2. FIND bench

    return call_not_found args if args.none?

    bench = args[0]

    log({bench:})

    begin
      bench_klass = Liza.const "#{bench}_bench"
    rescue Liza::ConstNotFound
      bench_klass = NotFoundBench
    end

    # 3. CALL

    bench_klass.call args[1..-1]
  end

  def self.call_not_found args
    Liza::NotFoundBench.call args
  end

end
