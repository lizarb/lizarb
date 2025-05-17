class DevSystem::CoffeeConverterShell < DevSystem::ConverterShell
  require "coffee-script"

  # https://github.com/rails/ruby-coffee-script

  def self.call(menv)
    super
    
    string = menv[:convert_in]
    menv[:convert_out] = CoffeeScript.compile string
  rescue => e
    raise if menv[:raise_errors]
    log stick :light_white, :red, :b, "#{e.class}: #{e.message}"
    menv[:error] = e
    menv[:convert_out] = menv[:convert_in]
  ensure
    nil
  end

end
