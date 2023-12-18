class DevSystem::FormatCommand < DevSystem::SimpleCommand
  
  # liza format FORMAT FILENAME

  def call_default
    log :lower, "args = #{args.inspect}"

    raise ArgumentError, "args[0] must be present" unless args[0]

    format = args[0].to_sym
    raise ArgumentError, "formatter #{format.inspect} not found" unless DevBox.format? format

    fname = args[1]
    raise ArgumentError, "fname must be present" unless FileShell.file? fname

    content = TextShell.read fname

    fname = "#{fname}.#{format}"
    content = DevBox.format format, content

    TextShell.write fname, content
  end
  
end
