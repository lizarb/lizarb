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
      env[:format_to] = env[:format_from]
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

  def convert?(from, to)
    from, tp = from.to_sym, to.to_sym
    converters.values.any? { _1[:from] == from and _1[:to] == to }
  end

  def convert env
    format_from = env[:format_from] = env[:format_from].to_sym
    format_to = env[:format_to] = env[:format_to].to_sym
    if convert? format_from, format_to
      converter = converters[format_from][:shell] ||= Liza.const("#{format_from}_converter_shell")
      log :higher, "converter found: #{converter}"
      converter.call env
    else
      log :lower, "converter #{format_from.inspect} to #{format_to.inspect} not found. converters: #{converters.inspect}"
      env[:convert_out] = env[:convert_in]
    end
  end

  section :rendering

  def renderer format, shell_key = format, options = {}
    renderers[shell_key] = {
      format: format,
      options: options
    }
  end

  def renderers
    @renderers ||= {}
  end

  def render? format
    renderers.key? format.to_sym
  end

end
