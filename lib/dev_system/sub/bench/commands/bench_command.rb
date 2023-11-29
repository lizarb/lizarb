class DevSystem::BenchCommand < DevSystem::Command

  def self.call args
    # 1. LOG

    log "args = #{args.inspect}"

    # 2. FIND bench

    return NotFoundBench.call args if args.none?

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

end
