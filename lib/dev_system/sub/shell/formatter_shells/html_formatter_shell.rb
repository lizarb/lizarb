class DevSystem::HtmlFormatterShell < DevSystem::FormatterShell

  def self.default_options
    DevBox[:shell].formatters[:html][:options]
  end

  # https://github.com/threedaymonk/htmlbeautifier

  def self.format string, options = {}
    log :lower, "default_options = #{default_options.inspect} | options = #{options.inspect}"

    options = default_options.merge options if options.any? && default_options.any?
    
    log :lower, "#{string.size} chars (options: #{options.inspect})"

    require "htmlbeautifier"
    HtmlBeautifier.beautify string
  end

end
