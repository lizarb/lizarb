class DevSystem
  class NotFoundCommand < Command

    def self.call args
      # 1. LOG

      log :higher, "Called #{self}.#{__method__} with args #{args}"
      puts

      # 2. FIND commands

      App.eager_load_all
      commands = Liza::Command.descendants

      log "Liza comes with #{commands.count} commands you can use."
      puts

      log "Here they are:"
      puts

      # 3. LIST commands

      keys = commands.map { |k| k.last_namespace.snakecase[0..-9] }.sort
      keys.each { |s| log "liza #{s}" }
    end

  end
end
