class DevSystem::NotFoundCommand < DevSystem::SimpleCommand

  def before
    super
    env[:command_action] = "default"
  end

  def call_default
    is_global = App.global?
    self.log_level 1 if is_global

    app_shell = AppShell.new

    failed_name = env[:command_name_original]

    app_shell.filter_by_unit Command

    if is_global
      app_shell.filter_in_units NewCommand, NotFoundCommand
    else
      app_shell.filter_out_units BaseCommand, SimpleCommand, NewCommand
      app_shell.filter_by_name_including failed_name if failed_name
    end

    structures = app_shell.get_structures.reject(&:empty?)
    log "structures: #{structures.count}"

    if structures.empty?
      log stick :black, :green, "No results found for '#{failed_name}'"
      app_shell.undo_filter!
      structures = app_shell.get_structures
    end
    structures = app_shell.get_structures.reject(&:empty?)

    structures.each do |structure|
      if log? :normal
        puts typo.h1 structure.name.to_s.upcase, structure.color
      end
      
      next if structure.empty?
      puts
      structure.layers.each do |layer|
        next if layer.objects.empty?

        if log? :normal
          m = "h#{layer.level}"
          name = layer.level==1 ? structure.name.to_s.upcase : layer.name.to_s
          puts typo.send m, name, layer.color unless layer.level==3

          puts stick layer.color, layer.path
          puts
        end

        layer.objects.each { print_class _1 }
        puts
      end
    end
  end

  # print helpers

  def print_class klass, description: nil
    return if [NotFoundCommand].include? klass

    sidebar_length = 30
    klass.get_command_signatures.each do |signature|
      signature[:name] =
        signature[:name].empty? \
          ? klass.token.to_s
          : "#{klass.token}:#{signature[:name]}"
      #
    end.sort_by { _1[:name] }.map do |signature|
      puts [
        "liza #{signature[:name]}".ljust(sidebar_length),
        (description or signature[:description])
      ].join ""
    end
  end
  
  # def print_global
  #   klasses = {
  #     NewCommand => "# Create a new project or script",
  #     NotFoundCommand => "# This command",
  #   }

  #   klasses.each { print_class _1, description: _2 }

  #   5.times { puts }
  # end

end
