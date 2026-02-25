class DevSystem::MdConverterShell < DevSystem::ConverterShell
  require "commonmarker"

  # https://github.com/gjtorikian/commonmarker#usage

  def self.call(menv)
    super

    string = menv[:convert_in]
    menv[:convert_out] = Commonmarker.to_html string
  rescue => e
    raise if menv[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    menv[:error] = e
    menv[:convert_out] = menv[:convert_in]
  ensure
    nil
  end

end
