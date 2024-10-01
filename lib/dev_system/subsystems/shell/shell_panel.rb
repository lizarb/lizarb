class DevSystem::ShellPanel < Liza::Panel

  #

  def formatter format, shell_key = format, options = {}
    formatters[shell_key] = {
      format: format,
      options: options
    }
  end

  def formatters
    @formatters ||= {}
  end

  def format? format
    formatters.key? format.to_sym
  end

  def format env
    format = env[:format] = env[:format].to_sym
    if format? format
      formatter = formatters[format][:shell] ||= Liza.const("#{format}_formatter_shell")
      log :higher, "formatter found: #{formatter}"
      formatter.call env
    else
      log :higher, "formatter not found"
      env[:format_out] = env[:format_in]
    end
  end

  #

  def converter to, from, shell_key = from, options = {}
    hash = {
      to: to.to_sym,
      from: from.to_sym,
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

  def convert env
    format = env[:format] = env[:format].to_sym
    if convert? format
      converter = converters[format][:shell] ||= Liza.const("#{format}_converter_shell")
      log :higher, "converter found: #{converter}"
      converter.call env
    else
      log :higher, "converter not found"
      env[:convert_out] = env[:convert_in]
    end
  end

end
