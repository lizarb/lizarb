class PrimeSystem::PumlConverterShell < DevSystem::ConverterShell

  section :converter

  def self.call(menv)
    super

    kroki_options = default_options.slice(:kroki_url)
    menv[:convert_out] = KrokiClient.request_puml(menv[:convert_in], kroki_options)
  rescue => e
    raise if menv[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    menv[:error] = e
    menv[:convert_out] = "#{e.class}: #{e.message}"
  ensure
    add_source(menv) if $coding or menv[:add_source]
    # add_source(menv) if menv[:add_source]
    menv
  end

  def self.add_source(menv)
    menv[:convert_out] += <<STRING

<!--
HELP MAKE THIS DIAGRAM BETTER, HERE IS THE SOURCE:
#{menv[:convert_in].gsub("-->", "--/>")}
-->
STRING
  end

end
