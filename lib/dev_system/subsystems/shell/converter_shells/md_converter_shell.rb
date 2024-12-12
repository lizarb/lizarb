class DevSystem::MdConverterShell < DevSystem::ConverterShell
  require "commonmarker"

  # https://github.com/gjtorikian/commonmarker#usage

  def self.call(env)
    super

    string = env[:convert_in]
    env[:convert_out] = CommonMarker.render_html string, :DEFAULT
  rescue => e
    raise if env[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    env[:error] = e
    env[:convert_out] = env[:convert_in]
  ensure
    nil
  end

end
