class DevSystem::CoffeeConverterShell < DevSystem::ConverterShell
  require "coffee-script"

  # https://github.com/rails/ruby-coffee-script

  def self.call(env)
    super
    
    string = env[:convert_in]
    env[:convert_out] = CoffeeScript.compile string
  rescue => e
    raise if env[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    env[:error] = e
    env[:convert_out] = env[:convert_in]
  ensure
    nil
  end

end
