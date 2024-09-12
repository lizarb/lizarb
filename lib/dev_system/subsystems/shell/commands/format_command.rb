class DevSystem::FormatCommand < DevSystem::SimpleCommand
  
  # liza format FORMAT FILENAME

  def call_default
    log :higher, "args = #{args.inspect}"

    return call_help if simple_args.count < 2

    format = simple_arg(0).to_sym
    fname = simple_arg(1)
    content = TextShell.read fname
    log "IN:"
    puts content if log? :normal

    fname = "#{fname}.#{format}"
    format_env = {format: format, format_in: content}
    DevBox.format format_env
    content = format_env[:format_out]

    log "OUT:"
    puts content if log? :normal

    TextShell.write fname, content
  end

  def call_help
    puts
    puts "Usage: liza format FORMAT FILENAME"
    puts "  FORMAT - format name (#{ valid_formats.join(", ") })"
    puts "  FILENAME - file name (a.html)"
    puts
  end

  private

  def valid_formats
    DevBox[:shell].formatters.keys
  end
  
end
