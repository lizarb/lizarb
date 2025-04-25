class PrimeSystem::PumlConverterShell < DevSystem::ConverterShell

  section :converter

  def self.call(env)
    super

    env[:convert_out] = CachedKrokiClient.request_puml(env[:convert_in])
  rescue => e
    raise if env[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    env[:error] = e
    env[:convert_out] = env[:convert_in]
  ensure
    nil
  end

end
