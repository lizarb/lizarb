class DevSystem::CoffeeConverterShell < DevSystem::ConverterShell

  def self.default_options
    DevBox[:shell].converters[:coffee][:options]
  end

  # https://github.com/rails/ruby-coffee-script

  def self.convert string, options = {}
    log :higher, "default_options = #{default_options.inspect} | options = #{options.inspect}"

    options = default_options.merge options if options.any? && default_options.any?
    
    log :higher, "#{string.size} chars (options: #{options.inspect})"

    require "coffee-script"
    
    CoffeeScript.compile string
  rescue ExecJS::RuntimeError => e
    log :highest, "ExecJS::RuntimeError: #{e.message.inspect}"
    string
  end

end
