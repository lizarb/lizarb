class DevSystem::ShellConvertCommand < DevSystem::SimpleCommand
  
  # liza shell_convert FORMAT FILENAMES

  def call_default
    valid_converters = Shell.panel.converters.keys
    color = system.color

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

      TextShell.write fname, content
    end
  end

end
