class DevSystem::HtmlFormatterShell < DevSystem::FormatterShell
  require "htmlbeautifier"

  # https://github.com/threedaymonk/htmlbeautifier

  def self.call(env)
    super
    
    env[:format_out] = HtmlBeautifier.beautify env[:format_in]
  rescue => e
    raise if env[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    env[:error] = e
    env[:format_out] = env[:format_in]
  ensure
    nil
  end

end
