class DevSystem::HtmlFormatterShell < DevSystem::FormatterShell
  require "htmlbeautifier"

  # https://github.com/threedaymonk/htmlbeautifier

  def self.call(env)
    super
    
    env[:format_out] = HtmlBeautifier.beautify env[:format_in]
    nil
  end

end
