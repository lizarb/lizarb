class DevSystem::HtmlFormatterGenerator < DevSystem::FormatterGenerator

  def self.default_options
    DevBox[:generator].formatters[:html][:options]
  end

  # https://github.com/threedaymonk/htmlbeautifier

  def self.format string, options = {}
    log_details = DevBox[:generator].get :log_details

    log "default_options = #{default_options.inspect} | options = #{options.inspect}" if log_details

    options = default_options.merge options if options.any? && default_options.any?
    
    log "#{string.size} chars (options: #{options.inspect})" if log_details

    HtmlBeautifier.beautify string
  end

end
