class DevSystem::ShellCommand < DevSystem::SimpleCommand

  shortcut :c, :convert
  shortcut :e, :eval
  shortcut :f, :format
  shortcut :p, :paths
  shortcut :l, :loc

  section :actions

  # liza shell
  def call_default
    puts
    puts "Lizarb                #{ Lizarb.source_location[0] }"
    puts "Liza                  #{ Liza.source_location[0] }"
    puts "App                   #{ App.source_location[0] }"
    puts
    puts "App.type              #{ App.type.inspect }"
    puts "App.name              #{ App.name.inspect }"
    puts "App.root              #{ App.root }/"
    puts "App.file              #{ App.file }"
    puts "App.directory         #{ App.directory }/"
    puts "App.systems_directory #{ App.systems_directory }/"
    puts "App.mode              #{ App.mode.inspect }"
    puts "App.full_name         #{ App.full_name.inspect }"
    puts "App.log_boot          #{ App.log_boot.inspect }"
    puts "App.log_level         #{ App.log_level.inspect }"
    puts "App.env_vars          #{ App.env_vars.inspect }"
    puts

    largest_system_name = AppShell.consts[:systems].keys.map(&:to_s).map(&:size).max
    AppShell.consts[:systems].each do |system_name, tree_system|
      system = tree_system["system"][0]
      length = largest_system_name + 15

      puts "#{
        "#{system.token == :dev ? "App.system" : "          "}   #{system.token.inspect}"
          .ljust(length)
          .sub(system.token.inspect, (stick :b, system.token.inspect, system.color).to_s)
      } #{
        system.source_location[0]
      }"
    end

    puts
  end

  # liza shell:convert FORMAT FILENAMES
  def call_convert
    valid_converters = Shell.panel.converters.keys
    color = cl.system.color

    log :normal, (stick color, "valid converters are #{valid_converters.map { stick :black, color, :b, _1.to_s }.map(&:to_s).join ', '}")

    set_input_arg 0 do |default|
      title = "Which converter are we going to use?"
      answer = InputShell.pick_one title, valid_converters
    end

    format = simple_arg(0).to_sym
    log :normal, (stick color, "converter is #{format}")

    set_input_arg 1 do |default|
      title = "Which files are we going to convert?"
      local_files = Dir["*.#{format}"]
      choices = local_files.map { [_1, _1] }.to_h
      selected = [choices.keys.first]
      answers = InputShell.multi_select title, choices, selected: selected
      answers.join(",")
    end

    fnames = simple_arg(1).to_s.split(",")
    log :normal, (stick color, "selected files are #{fnames.join ', '}")
    fnames.each do |fname|
      content = TextShell.read fname
      log :higher, (stick color, "IN:")
      puts content if log? :higher

      format_to = DevBox[:shell].converters[format][:to]
      fname = "#{fname}.#{format_to}"
      convert_env = {format: format, convert_in: content}
      DevBox.convert convert_env

      content = convert_env[:convert_out]
      log :higher, (stick color, "OUT:")
      puts content if log? :higher

      FileShell.write_text fname, content
    end
  end

  # liza shell:eval
  def call_eval
    s = args.join(' ')
    log :low, (stick cl.system.color, "evaluating:")
    log :lower, s.inspect
    ret = eval s
    log :low, (stick cl.system.color, "returned:")
    log :lower, ret.inspect
  end

  # liza shell:format FORMAT FILENAME
  def call_format
    valid_formats = Shell.panel.formatters.keys
    color = cl.system.color

    log :normal, (stick color, "valid formatters are #{valid_formats.map { stick :black, color, :b, _1.to_s }.map(&:to_s).join ', '}")

    set_input_arg 0 do |default|
      title = "Which formatter are we going to use?"
      choices = valid_formats
      InputShell.pick_one title, choices
    end
    
    format = simple_arg(0).to_sym
    log :normal, (stick color, "formatter is #{format}")

    set_input_arg 1 do |default|
      title = "Which files are we going to format?"
      local_files = Dir["*.#{format}"]
      choices = local_files.map { [_1, _1] }.to_h
      selected = [choices.keys.first]
      answers = InputShell.multi_select title, choices, selected: selected
      answers.join(",")
    end

    fnames = simple_arg(1).to_s.split(",")
    log :normal, (stick color, "selected files are #{fnames.join ', '}")
    fnames.each do |fname|
      content = TextShell.read fname
      log :higher, (stick color, "IN:")
      puts content if log? :higher

      format_to = DevBox[:shell].formatters[format][:to]
      fname = "#{fname}.#{format_to}"
      format_env = {format: format, format_in: content}
      DevBox.format format_env

      content = format_env[:format_out]
      log :higher, (stick color, "OUT:")
      puts content if log? :higher

      FileShell.write_text fname, content
    end
  end

  def params_input_field_globals(field_name, default)
    title = "Which globals are we going to show?"
    choices = {"$LOAD_PATH" => "paths", "$LOADED_FEATURES" => "features"}
    array = InputShell.multi_select title, choices, selected: :all
    array.join(",")
  end

  # liza shell:globals
  # liza shell:globals globals=paths
  # liza shell:globals globals=paths,features
  def call_globals
    puts

    params.expect :globals, :array
    globals = params[:globals]

    if globals.include? "paths"
      puts "$LOAD_PATH"
      $LOAD_PATH.each do |path|
        puts path
      end
      puts
    end

    if globals.include? "features"
      puts "$LOADED_FEATURES"
      $LOADED_FEATURES.each do |path|
        puts path
      end
      puts
    end
  end

  def params_input_field_domains(field_name, default)
    title = "params[:#{field_name}] - Which domains are we going to inspect?"
    domains = AppShell.get_writable_domains
    array=InputShell.pick_domains domains, default, title
    array.join ","
  end

  # liza shell:loc
  # liza shell:loc domains=core
  # liza shell:loc domains=micro,desk
  def call_loc
    app_shell = AppShell.new

    params.expect :domains, :array
    domains = params[:domains]
    log "domains = #{domains}"
    app_shell.filter_by_domains domains

    app_shell.filter_by_any_name_including params.args if params.args.any?

    total = {loc: 0, c: 0, cm: 0, im: 0, views: 0}

    # silence log
    CoderayGemShell.log_level :low

    app_shell.get_domains.each do |domain|
      next if domain.empty?
      puts
      puts typo.h1 domain.name.to_s, domain.color
      puts

      domain_total = {loc: 0, c: 0, cm: 0, im: 0, views: 0}

      domain.layers.each do |layer|
        next if layer.objects.empty?

        m = "h#{layer.level}"
        puts typo.send m, layer.name.to_s, layer.color unless layer.level == 1

        puts stick layer.color, layer.path
        puts

        layer_total = {loc: 0, c: 0, cm: 0, im: 0, views: 0}
        layer.objects.each do |object|
          object_type = object.class == Module ? "module" : "class"

          loc = CoderayGemShell.loc_for(object)

          sections = object.sections.to_h rescue {}
          # sections_count = sections.count
          consts = sections.map { _2[:constants].count }.sum
          cm = sections.map { _2[:class_methods].count }.sum
          im = sections.map { _2[:instance_methods].count }.sum

          views = object.erbs_defined.count rescue 0

          layer_total[:loc] += loc
          layer_total[:c] += consts
          layer_total[:cm] += cm
          layer_total[:im] += im
          layer_total[:views] += views

          domain_total[:loc] += loc
          domain_total[:c] += consts
          domain_total[:cm] += cm
          domain_total[:im] += im
          domain_total[:views] += views

          total[:loc] += loc
          total[:c] += consts
          total[:cm] += cm
          total[:im] += im
          total[:views] += views

          content = String.new
          content << "{ "
          content << ":loc => #{loc.to_s.rjust_blanks 4}, "


          # content << ":sections => #{sections_count}, "
          content << ":c => #{consts.to_s.rjust_blanks 2}, "
          content << ":cm => #{cm.to_s.rjust_blanks 2}, "
          content << ":im => #{im.to_s.rjust_blanks 2}, "
          content << ":views => #{views.to_s.rjust_blanks 2} "

          content << "}"

          content = stick layer.color, content

          sidebar = "#{object_type} #{(typo.color_class object)}"
          count = object.to_s.length + object_type.length + 2
          size = Log.panel.sidebar_size - count
          sidebar << " " * size if size > 0

          log content, sidebar: sidebar
        end
        puts

        sidebar = "small subtotal"
        size = Log.panel.sidebar_size - sidebar.length - 1
        sidebar << " " * size if size > 0

        content = "{ "
        content << ":loc => #{layer_total[:loc].to_s.rjust_blanks 4}, "
        content << ":c => #{layer_total[:c].to_s.rjust_blanks 2}, "
        content << ":cm => #{layer_total[:cm].to_s.rjust_blanks 2}, "
        content << ":im => #{layer_total[:im].to_s.rjust_blanks 2}, "
        content << ":views => #{layer_total[:views].to_s.rjust_blanks 2} "
        content << "}"

        log content, sidebar: sidebar

        puts
      end

      sidebar = "SUBTOTAL"
      size = Log.panel.sidebar_size - sidebar.length - 1
      sidebar << " " * size if size > 0

      content = "{ "
      content << ":loc => #{domain_total[:loc].to_s.rjust_blanks 4}, "
      content << ":c => #{domain_total[:c].to_s.rjust_blanks 2}, "
      content << ":cm => #{domain_total[:cm].to_s.rjust_blanks 2}, "
      content << ":im => #{domain_total[:im].to_s.rjust_blanks 2}, "
      content << ":views => #{domain_total[:views].to_s.rjust_blanks 2} "
      content << "}"
      content = stick :b, :lightest_white, :darkest_black, content

      log content, sidebar: sidebar
    end
    puts

    sidebar = "TOTAL"
    size = Log.panel.sidebar_size - sidebar.length - 1
    sidebar << " " * size if size > 0

    content = "{ "
    content << ":loc => #{total[:loc].to_s.rjust_blanks 4}, "
    content << ":c => #{total[:c].to_s.rjust_blanks 2}, "
    content << ":cm => #{total[:cm].to_s.rjust_blanks 2}, "
    content << ":im => #{total[:im].to_s.rjust_blanks 2}, "
    content << ":views => #{total[:views].to_s.rjust_blanks 2} "
    content << "}"
    content = stick :b, :black, :white, content

    puts
    log content, sidebar: sidebar
    puts
    puts
    puts
    puts stick :b, :black, :white, "loc:   lines of code"
    puts stick :b, :black, :white, "c:     constants"
    puts stick :b, :black, :white, "cm:    class methods"
    puts stick :b, :black, :white, "im:    instance methods"
    puts stick :b, :black, :white, "views: views"
    puts
  end

end
