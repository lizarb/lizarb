class DevSystem::MdConverterShell < DevSystem::ConverterShell
  require "commonmarker"

  # https://github.com/gjtorikian/commonmarker#usage

  def self.call(env)
    super

    string = env[:convert_in]
    env[:convert_out] = CommonMarker.render_html string, :DEFAULT
    nil
  end

end
