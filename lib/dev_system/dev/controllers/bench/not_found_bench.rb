class DevSystem::NotFoundBench < DevSystem::Bench

  def self.call args
    # 1. LOG

    log "args = #{args.inspect}"
    puts

    # 2. FIND generators

    App.load_all
    benches = Liza::Bench.descendants
    benches -= ignored_benches

    # 3. LIST benches

    keys = benches.map { _1.last_namespace.snakecase[0..-7] }.uniq.sort

    log "Liza comes with #{keys.count} benches you can use."
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
