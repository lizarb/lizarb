class DevSystem::CoffeeConverterShell < DevSystem::ConverterShell
  require "coffee-script"

  # https://github.com/rails/ruby-coffee-script

  def self.call(env)
    super
    
    string = env[:convert_in]
    env[:convert_out] = CoffeeScript.compile string
    nil
  rescue ExecJS::RuntimeError => e
    log :highest, "ExecJS::RuntimeError: #{e.message.inspect}"
    env[:convert_out] = string
    nil
  end

end
