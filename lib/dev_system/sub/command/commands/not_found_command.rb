class DevSystem::NotFoundCommand < DevSystem::Command

  def self.call args
    # 1. LOG

    rescuer = args.pop if args.last.is_a? Hash
    log :lower, "rescuer = #{rescuer.inspect}" if rescuer

    log "args = #{args.inspect}"
    puts

    # 2. FIND commands

    commands = commands_visible

    grouped_commands = App.systems.values.map { [_1, []] }.to_h
    grouped_commands[Object] = []
    grouped_commands = commands.inject(grouped_commands) do |h, c|
      ns = (c.to_s.include? "::") ? c.system : Object
      h[ns] << c
      h
    end

    grouped_commands.select! do |ns, controllers|
      controllers.any?
    end

    # 3. LIST commands

    keys = commands.map { _1.last_namespace.snakecase[0..-9] }.uniq.sort

    log "#{grouped_commands.values.flatten.count.to_s} command(s) found"
    puts

    longest_name = grouped_commands.keys.map { _1.to_s.length }.max

    grouped_commands.each do |ns, controllers|
      if ns == Object
        color = :white
        title = "App".ljust longest_name
        path = "#{App.relative_path}/dev/**/*_command.rb"
      else
        color = ns.color
        title = ns.to_s.ljust longest_name
        path = "lib/#{ns.to_s.snakecase}/**/*_command.rb"
      end
      
      puts  [
        (stick :b, color, "#{title.ljust 60-2} "),
        (stick :onyx, "#{controllers.count.to_s.rjust_zeroes 2} command(s) found in #{path}"),
      ].join " "

      puts
      controllers.sort_by do |c|
        c.token
      end.each do |c|
        log "liza #{c.token}"
      end
      puts
    end
    puts
  end

  #

  def self.commands_visible
    commands = DevSystem::Command.descendants
    commands -= commands_ignored
    commands
  end

  def self.commands_visible
    [
      DevSystem::NotFoundCommand,
      DevSystem::NewCommand,
      DevSystem::GenerateCommand,
    ]
  end if App.global?

  def self.commands_ignored
    [
      self,
      DevSystem::NotFoundCommand,
      DevSystem::NewCommand,
      (DevSystem::NarrativeMethodCommand if defined? NarrativeMethodCommand),
      *DevSystem::InputCommand.and_descendants,
      DevSystem::BaseCommand,
      DevSystem::SimpleCommand,
    ].uniq.compact
  end

end
