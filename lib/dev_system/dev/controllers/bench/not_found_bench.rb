class DevSystem
  class NotFoundBench < Bench

    def self.call args
      # 1. LOG

      log :higher, "Called #{self}.#{__method__} with args #{args}"
      puts

      # 2. FIND generators

      App.eager_load_all
      benches = Liza::Bench.descendants

      log "Liza comes with #{benches.count} benches you can use."
      puts

      log "Here they are:"
      puts

      # 3. LIST benches

      keys = benches.map { |k| k.last_namespace.snakecase[0..-7] }.sort
      keys.reject! { |s| s == "not_found" }
      keys.each { |s| log "liza bench #{s}" }
    end

  end
end
