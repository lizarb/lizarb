class DevSystem::GenerateCommand < DevSystem::Command

  def call args
    log :lower, "args = #{args}"

    DevBox[:generator].call args
  end

  def self.format args
    log :lower, "args = #{args.inspect}"

    raise ArgumentError, "args[0] must be present" unless args[0]

    format = args[0].to_sym
    raise ArgumentError, "formatter #{format.inspect} not found" unless DevBox[:generator].format? format

    fname = args[1]
    raise ArgumentError, "fname must be present" unless FileShell.file? fname

    content = TextShell.read fname

    fname = "#{fname}.#{format}"
    content = DevBox.format format, content

    TextShell.write fname, content
  end

  def self.convert args
    log :lower, "args = #{args.inspect}"

    raise ArgumentError, "args[0] must be present" unless args[0]

    format = args[0].to_sym
    raise ArgumentError, "converter #{format.inspect} not found" unless DevBox[:generator].convert? format

    fname = args[1]
    raise ArgumentError, "fname must be present" unless FileShell.file? fname

    content = TextShell.read fname

    to_format = DevBox[:generator].converters[format][:to]
    fname = "#{fname}.#{to_format}"
    content = DevBox.convert format, content

    TextShell.write fname, content
  end

end
