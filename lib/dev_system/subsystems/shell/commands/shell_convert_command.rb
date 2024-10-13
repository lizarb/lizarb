class DevSystem::ShellConvertCommand < DevSystem::SimpleCommand
  
  # liza shell_convert FORMAT FILENAME

  def call_default
    log :higher, "args = #{args.inspect}"

    return help if simple_args.count < 2

    format = simple_arg(0).to_sym
    fname = simple_arg(1)
    content = TextShell.read fname
    log "IN:"
    puts content if log? :normal

    format_to = DevBox[:shell].converters[format][:to]
    fname = "#{fname}.#{format_to}"
    convert_env = {format: format, convert_in: content}
    DevBox.convert convert_env
    DevBox.convert convert_env
    DevBox.convert convert_env
    content = convert_env[:convert_out]

    log "OUT:"
    puts content if log? :normal

    TextShell.write fname, content
  end

  def help
    puts
    puts "Usage: liza convert FORMAT FILENAME"
    puts "  FORMAT - format name (#{ valid_formats.join(", ") })"
    puts "  FILENAME - file name (a.haml)"
    puts
  end

  private

  def valid_formats
    DevBox[:shell].converters.keys
  end

  
end
