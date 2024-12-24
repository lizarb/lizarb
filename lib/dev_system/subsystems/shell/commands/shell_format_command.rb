class DevSystem::ShellFormatCommand < DevSystem::SimpleCommand
  
  # liza shell_format FORMAT FILENAME

  def call_default
    valid_formats = Shell.panel.formatters.keys
    color = system.color

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

      TextShell.write fname, content
    end
  end

end
