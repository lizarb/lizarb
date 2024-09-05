class DevSystem::FormatterShell < DevSystem::Shell
  division!

  def self.default_options
    key = last_namespace.snakecase.split("_").first.to_sym
    DevBox[:shell].formatters[key][:options]
  rescue => e
    log "e = #{e.inspect}"
    {}
  end

  def self.call(env)
    super

    options = env[:format_options]
    log :higher, "default_options = #{default_options.inspect}"
    log :higher, "options = #{options.inspect}"
    options = \
      if options.nil?
        default_options
      else
        default_options.merge options
      end
    env[:format_options] = options
    log :higher, "options = #{options.inspect}"

    nil
  end

end
