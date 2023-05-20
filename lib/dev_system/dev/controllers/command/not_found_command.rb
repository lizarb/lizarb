class DevSystem::NotFoundCommand < DevSystem::Command

  def self.call args
    # 1. LOG

    log "args = #{args.inspect}"
    puts

    # 2. FIND commands

    App.load_all
    commands = Liza::Command.descendants
    commands -= ignored_commands

    # 3. LIST commands

    keys = commands.map { _1.last_namespace.snakecase[0..-9] }.uniq.sort

    log "Liza comes with #{keys.count} commands you can use."
    log "Here they are:"
    puts

    keys.each { |s| log "liza #{s}" }
  end

  def self.ignored_commands
    [
      self,
      DevSystem::NotFoundCommand,
      DevSystem::NewCommand,
      DevSystem::TerminalCommand,
      (DevSystem::NarrativeMethodCommand if defined? NarrativeMethodCommand),
    ].uniq.compact
  end

  if $APP == "app_global"
    def self.ignored_commands
      [
        self,
        DevSystem::NotFoundCommand,
        DevSystem::BenchCommand,
        DevSystem::GenerateCommand,
        DevSystem::TestCommand,
      ].uniq.compact
    end
  end

end
