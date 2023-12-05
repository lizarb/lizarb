class DevSystem::ConvertCommand < DevSystem::SimpleCommand
  
  # liza convert FORMAT FILENAME

  def call_default
    args = env[:args]
    log :lower, "args = #{args.inspect}"

    raise ArgumentError, "args[0] must be present" unless args[0]

    format = args[0].to_sym
    raise ArgumentError, "converter #{format.inspect} not found" unless DevBox.convert? format

    fname = args[1]
    raise ArgumentError, "fname must be present" unless FileShell.file? fname

    content = TextShell.read fname

    to_format = DevBox.converters[format][:to]
    fname = "#{fname}.#{to_format}"
    content = DevBox.convert format, content

    TextShell.write fname, content
  end

  
end
