class DevSystem::ShellPanel < Liza::Panel
  class FormatterError < Error; end
  class ConverterError < Error; end

  #

  def formatter format, shell_key = format, options = {}
    shell = options[:shell] || Liza.const("#{format}_formatter_shell")

    formatters[shell_key] = {
      format: format,
      shell: shell,
      options: options
    }
  end

  def formatters
    @formatters ||= {}
  end

  def format? format
    formatters.key? format.to_sym
  end

  def format! format, string
    format = format.to_sym
    if format? format
      log :higher, "formatter found"
      formatters[format][:shell].format string
    else
      log :higher, "formatter not found"
      raise FormatterError, "no formatter for #{format.inspect}"
    end
  end

  def format format, string, options = {}
    format = format.to_sym
    if format? format
      log :higher, "formatter found"
      formatters[format][:shell].format string, options
    else
      log :higher, "formatter not found"
      string
    end
  end

  #

  def converter to, from, shell_key = from, options = {}
    shell = options[:shell] || Liza.const("#{shell_key}_converter_shell")

    hash = {
      to: to.to_sym,
      from: from.to_sym,
      shell: shell,
      options: options
    }
    converters[shell_key] = hash
    converters_to[to] ||= []
    converters_to[to] << hash
  end

  def converters
    @converters ||= {}
  end

  def converters_to
    @converters_to ||= {}
  end

  def convert? format
    format = format.to_sym
    converters.values.any? { _1[:from] == format }
  end

  def convert! format, string, options = {}
    format = format.to_sym
    if convert? format
      log :higher, "converter found"
      converters[format][:shell].convert string
    else
      log :higher, "converter not found"
      raise ConverterError, "no converter for #{format.inspect}"
    end
  end

  def convert format, string, options = {}
    format = format.to_sym
    if convert? format
      log :higher, "converter found"
      converters[format][:shell].convert string, options
    else
      log :higher, "converter not found"
      string
    end
  end

end
