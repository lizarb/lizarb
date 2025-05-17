class DevSystem::HtmlFormatterShell < DevSystem::FormatterShell
  require "htmlbeautifier"

  # https://github.com/threedaymonk/htmlbeautifier

  def self.call(menv)
    super
    
    menv[:format_out] = HtmlBeautifier.beautify menv[:format_in]
  rescue => e
    raise if menv[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    menv[:error] = e
    menv[:format_out] = menv[:format_in]
  ensure
    nil
  end

end
