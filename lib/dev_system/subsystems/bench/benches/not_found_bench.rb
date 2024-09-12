class DevSystem::NotFoundBench < DevSystem::Bench

  def self.call env
    super
    # 1. LOG

    args = env[:args]
    log "args = #{args.inspect}"
    puts

    # 2. FIND generators

    Lizarb.eager_load!
    benches = Liza::Bench.descendants
    benches -= ignored_benches

    # 3. LIST benches

    keys = benches.map { _1.last_namespace.snakecase[0..-7] }.uniq.sort

    log "This app has #{keys.count} benches you can use."
    log "Here they are:"
    puts

    keys.each { |s| log "liza bench #{s}" }
  end

  def self.ignored_benches
    [
      self,
      DevSystem::NotFoundBench,
      (DevSystem::SortedBench if defined? SortedBench),
    ].uniq.compact
  end

end
